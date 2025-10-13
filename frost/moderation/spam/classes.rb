# frozen_string_literal: true

# A set of common data classes used for anti-spam tracking.
module Moderation
  # Generic storage bucket for tracking user spam.
  class StorageBucket
    # @return [Member] the server member this storage bucket is for.
    attr_reader :member

    # @return [Integer, nil] the last time at which the bucket was used for a drain.
    attr_reader :acted_at

    # @return [Array<Messagable>] the messages that've been drained from the bucket.
    attr_reader :depleted

    # @return [Array<Messagable>] the de-hydrated messages stored within the bucket.
    attr_reader :messages

    # @!visibility private
    def initialize(user)
      @member = user
      @depleted = []
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
    def shift_each
      yield(@messages.shift.tap { @depleted << it }) while @messages.any?

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

    # Timeout the member this storage bucket is for.
    # @param duration [Time] the time at when the user's mute should expire.
    # @return [void] this method does not return usable data for the caller.
    def timeout_member(duration)
      @timed_out = @timed_out.nil? || return

      data = {
        reason: "Auto-mute for spamming",
        communication_disabled_until: duration&.iso8601
      }

      Discordrb::API::Server.update_member(BOT.token, @member.server.id, @member.id, **data) rescue nil
    end
  end

  # Generic lightweight wrapper over discordrb messages.
  class Messagable
    # @return [Integer] the associtaed message ID.
    attr_reader :id

    # @return [Array<String>] the parsed URI objects.
    attr_reader :uris

    # @return [Integer] the ID of the associated channel.
    attr_reader :channel_id

    # @return [Array<Attachemnt>] the attached message files.
    attr_reader :attachments

    # @!visibility private
    def initialize(message, uris)
      @id = message.id
      @uris = uris.map(&:to_s)
      @channel_id = message.channel.id
      @attachments = message.attachments
    end

    # Delete this message from the source location.
    # @return [void] this method does not return usable data.
    def delete
      Discordrb::API::Channel.delete_message(BOT.token, @channel_id, @id) rescue nil
    end
  end

  # Generic class for storing log stashes.
  class Loggable
    # @return [Boolean] if the current log has already been bounced.
    attr_writer :bounced

    # @return [Array<Messagable>] the messages that have been deleted.
    attr_reader :messages

    # @!visibility private
    def initialize
      @bounced = nil
      @messages = []
    end

    # Fetch the links that were deleted in the log stash.
    # @return [Array<URI>] the hyperlinks that were deleted.
    def links
      @messages.flat_map(&:uris).uniq.take(15)
    end

    # Fetch the files that were deleted in the long stash.
    # @return [Array<Attachment>] the attachments that were deleted.
    def files
      @messages.flat_map(&:attachments).uniq.take(15)
    end

    # Whether this log stash has been marked as being bounced.
    # @return [true, false] whether the log stash is bounced or not.
    def bounced?
      @bounced.nil? ? false : @bounced
    end

    # Append a results hash to the log stash.
    # @param messages [Array<Messagable>] the log data to append.
    # @return [void] the method does not return any usable data for the user.
    def <<(messages)
      @messages.push(*messages)
    end
  end
end
