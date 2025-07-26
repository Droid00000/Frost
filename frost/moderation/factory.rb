# frozen_string_literal: true

# A set of common data classes for anti-spam tracking.
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
    # @param uris [Array<URI>, nil] the urls to store in the message.
    # @return [Array<Messagable>] the collection of stored messages.
    def push(message, uris = nil)
      @messages << Messagable.new(message, uris)
    end

    # Yield each stored message in the array to the given block.
    # @return [Messagable] each stored Messagable will by yielded.
    def shift
      yield(@messages.shift) while @messages.any?

      @acted_at = Time.now.to_i
    end

    # Whether the bucket was recently used and is considered active.
    # @return [true, false] whether this bucket is currently active.
    def active?
      @acted_at.nil? || Time.now.to_i - @acted_at <= 60
    end

    # Whether the current storage bucket is pending automatic deletion.
    # @return [true, false] whether the current storage bucket is EOL.
    def dead?
      @acted_at.nil? || Time.now.to_i - @acted_at >= 3600
    end

    # Whether the current storage bucket needs to be emptied out.
    # @return [true, false] whether the current storage bucket is full.
    def full?
      active? || @messages.length >= 3
    end

    # Check and see how many unique channels are in the storage bucket.
    # @return [true, false] the amount of unique chanels in the bucket.
    def channel_count
      @messages.map(&:channel_id).uniq.length
    end
  end

  # Generic lightweight wrapper over discordrb messages.
  class Messagable
    # @return [Array<URI>] the parsed URI text objects.
    attr_reader :uris

    # @return [Integer] the ID of the associated channel.
    attr_reader :channel_id

    # @return [Integer] the ID of the associated message.
    attr_reader :message_id

    # @!visibility private
    def initialize(message, uris)
      @uris = uris
      @message_id = message.id
      @channel_id = message.channel.id
    end

    # Delete this message from the source location.
    # @return [void] this method does not return usable data.
    def delete
      Discordrb::API::Channel.delete_message(BOT.token, @channel_id, @message_id)
    end
  end

  # Base anti-spam module to be extended by all other modules.
  module SpamFactory
    # Check if the given user is exempt from spam filtering.
    # @param user [#roles] the user or member to check for.
    # @return [true, false] whether the user is exempt.
    def self.exempt?(user)
      return true unless user.respond_to?(:roles)

      user.roles.map(&:id).intersect?(SAFE_ROLES)
    end

    # Ensure a bucket exists for the given user.
    # @param user [#id] the user or member to create a bucket for.
    # @return [StorageBucket] the created storage bucket for the user.
    def self.make_bucket(user)
      MUTEX.synchronize { BUCKET[user.id] ||= StorageBucket.new }
    end

    # Drain the provided storage bucket.
    # @param bucket [StorageBucket] the storage bucket which should be drained.
    # @return [void] this method does not return usable data for the caller.
    def self.delete_spam(bucket)
      MUTEX.synchronize { bucket.shift { |message| message.delete } }
    end

    # Remove any dead buckets. The removal threshold is one hour (3600s).
    # @return [void] this method does not return usable data for the caller.
    def self.audit
      MUTEX.synchronize { BUCKET.delete_if { |_, value| value.dead? } }
    end

    # Merge multiple logging messages sent within a short time period into one.
    # @param user [#id] the user or member to create a logging bucket for.
    # @param value [Hash] the log data such as deleted message to log.
    def debounced_logger(user, value)
      MUTEX.synchronize do
        # Add the log message to the user's log stash
        LOGS[user.id] << value

        # If a debounce is already in progress, don't start another.
        LOGS[user.id].bouncing? ? return : LOGS[user.id].bounced
      end

      # Remove the entry entirely, since the user usually gets banned.
      sleep(15) && MUTEX.synchronize { logger(user, LOGS.delete(user.id)) }
    end
  end
end
