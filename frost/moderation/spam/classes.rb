# frozen_string_literal: true

# A set of common data classes used for anti-spam tracking.
module Moderation
  # Generic storage bucket for tracking user spam.
  class StorageBucket
    # @return [Integer, nil] the last time at which the bucket was used for a drain.
    attr_reader :acted_at

    # @return [Array<Messagable>] the de-hydrated messages stored within the bucket.
    attr_reader :messages

    # @!visibility private
    def initialize
      @messages = []
      @acted_at = nil
    end

    # Append a singular message to the current storage bucket.
    # @param message [Discordrb::Message] the message to de-hydrate.
    # @param uris [Array<URI>] the urls to store in the message.
    # @return [Array<Messagable>] the collection of stored messages.
    def push(message, uris = [])
      @messages << Messagable.new(message, uris)
    end

    # Yield each stored message in the array to the given block.
    # @return [Messagable] each stored Messagable will by yielded.
    def each
      yield(@messages.shift) while @messages.any?

      @acted_at = Time.now.to_i
    end

    # Whether the bucket was recently used and is considered active.
    # @return [true, false] whether this bucket is currently active.
    def active?
      @acted_at && (Time.now.to_i - @acted_at) <= 70
    end

    # Whether the current storage bucket is pending automatic deletion.
    # @return [true, false] whether the current storage bucket is EOL.
    def dead?
      @acted_at.nil? || (Time.now.to_i - @acted_at) >= 3600
    end

    # Whether the current storage bucket needs to be emptied out.
    # @return [true, false] whether the current storage bucket is full.
    def full?
      active? || @messages.length >= 3
    end

    # Check and see how many unique channels are in the storage bucket.
    # @return [Integer] the number of unique chanels in the bucket.
    def channel_count
      @messages.map(&:channel_id).uniq.length
    end
  end

  # Generic lightweight wrapper over discordrb messages.
  class Messagable
    # @return [Array<String>] the parsed URI objects.
    attr_reader :uris

    # @return [Integer] the ID of the associated channel.
    attr_reader :channel_id

    # @return [Integer] the ID of the associated message.
    attr_reader :message_id

    # @!visibility private
    def initialize(message, uris)
      @uris = uris.map(&:to_s)
      @message_id = message.id
      @channel_id = message.channel.id
    end

    # Delete this message from the source location.
    # @return [void] this method does not return usable data.
    def delete
      Discordrb::API::Channel.delete_message(BOT.token, @channel_id, @message_id)
    end
  end

  # Generic class for storing log stashes.
  class Loggable
    # @return [Integer] the amount of results that failed.
    attr_reader :failed

    # @return [Integer] the amount of results that were deleted.
    attr_reader :deleted

    # @return [Boolean] if the current log has already been bounced.
    attr_accessor :bounced

    # @!visibility private
    def initialize
      @links = []
      @failed = 0
      @deleted = 0
      @bounced = nil
    end

    # Fetch the links that were deleted in the log stash.
    # @return [Array<URI>] the hyperlinks that were deleted.
    def links
      @links.first(5).uniq
    end

    # Whether this log stash has been marked as being bounced.
    # @return [true, false] whether the log stash is bounced or not.
    def bounced?
      @bounced.nil? ? false : @bounced
    end

    # Append a results hash to the log stash.
    # @param hash [Hash<Symbol => Integer, Array>] the log data to append.
    # @return [void] the method does not return any usable data for the user.
    def <<(hash)
      @failed += hash[:failed] if hash[:failed]
      @links.push(*hash[:links]) if hash[:links]
      @deleted += hash[:deleted] if hash[:deleted]
    end
  end
end
