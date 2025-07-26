# frozen_string_literal: true

module Moderation
  # Module for managing attachment spam based actions.
  module FileSpam
    # Mutex that's mostly used when accessing buckets.
    MUTEX = Mutex.new

    # Create a way to keep track of debounced messages.
    LOGGER = Set.new

    # Used to actually track spam related messages sent.
    BUCKET = Hash.new

    # Add a message to the user's given message bucket.
    # @param key [Discordrb::Member] the member whose bucket to increment.
    # @param value [Discordrb::Events::MessageEvent] the message event to store.
    def self.increment_bucket(key, value)
      # Don't do anything if we don't have enough attachments.
      return if value.message.attachments.size < 3

      # Ensure the user's bucket exists.
      ensure_user_bucket_exists(key.id)

      BUCKET[key.id][0] << value.message
    end

    # Get a user's given message bucket.
    # @param key [Discordrb::Member] the member whose bucket to fetch.
    # @return [Queue, nil] the member's bucket, or `nil` if their bucket isn't big enough.
    def self.bucket(key)
      MUTEX.synchronize do
        return nil unless (bucket = BUCKET[key.id])

        return bucket.first if bucket[0].length >= 3

        return bucket.first if bucket[1] && Time.now - Time.at(bucket[1]) <= 60
      end
    end

    # Remove a single item from the user's bucket.
    # @param queue [Queue] the user's bucket to drain.
    # @param table [Hash] the table to use for appending results.
    def self.drain_bucket(queue, table)
      table[:deleted] << (value = queue.pop.tap(&:delete)) rescue table[:failed] << value
    end

    # send the spam logs to the logging channel.
    # @param user [Discordrb::Member] the member the spam entry is for.
    # @param logs [Array<Hash>] the logs to serialize and send to the channel.
    def self.logger(user, logs)
      # Create the descripton for the given embed.
      embed_description = lambda do |state|
        failed = logs.map { |log| log[:failed] }.map(&:size).sum
        deleted = logs.map { |log| log[:deleted] }.map(&:size).sum
        result = format(RESPONSE[1], failed, deleted, user.resolve_id)
        state ? ("> **Joined:** <t:#{user.joined_at.to_i}:R>\n" + result) : result
      end
    end
  end
end
