# frozen_string_literal: true

# A set of common data classes for anti-spam tracking.
module Moderation
  # Base anti-spam module to be extended by all other modules.
  module SpamFactory
    # This special hook creates the constants required
    #   by each anti-spam module to function correctly.
    def self.extended(target)
      # This creates the mutex that synchronizes data access
      #   between the bucket and logger.
      target.const_set(:MUTEX, Mutex.new)

      # This creates the hash that track's a user's spam state.
      target.const_set(:BUCKET, Hash.new)

      # Lastly, this creates the buffer which stores debounced
      #   logging messages that should be flushed and logged.
      target.const_set(:LOGGER, Hash.new do |hash, key|
        hash[key] = Loggable.new
      end)

      # Define all of the methods onto the target's singleton class.
      target.module_eval do
        # Set the timeout for the user associated with a given bucket.
        # @param bucket [StorageBucket] the storage bucket for the user.
        # @param channels [Array<Integer>] the channels the messages were spammed in.
        # @return [void] this method does not return any usable data for the caller.
        def self.set_timeout(bucket, channels)
          return unless channels.uniq.length >= 8

          bucket.timeout_member(Time.now + 604_800)
        end

        # Check if the given user is exempt from spam filtering.
        # @param user [#roles] the user or member to check for.
        # @return [true, false] whether the user is exempt.
        def self.exempt?(user)
          return true unless user.respond_to?(:roles)

          user.roles.map(&:id).intersect?(SAFE_ROLES)
        end

        # Fetch a user's storage bucket.
        # @param key [#id] the user or member whose storage bucket to fetch.
        # @return [StorageBucket, nil] the member's bucket, or `nil` for no bucket.
        def self.bucket(key)
          self::MUTEX.synchronize do
            return nil unless (bucket = self::BUCKET[key.id])

            bucket if bucket.full? || bucket.channel_count >= 4
          end
        end

        # Drain the provided storage bucket.
        # @param bucket [StorageBucket] the storage bucket which should be drained.
        # @return [Hash<Symbol => Integer, Array>] the results of the message deletion.
        def self.delete_spam(bucket)
          results = Hash.new { |map, key| map[key] = [] }

          self::MUTEX.synchronize do
            bucket.shift_each do |item|
              results[:deleted] << item if item.delete rescue nil

              set_timeout(bucket, bucket.depleted.map(&:channel_id))
            end
          end

          results
        end

        # Ensure a bucket exists for the given user.
        # @param user [#id] the user or member to create a bucket for.
        # @return [StorageBucket] the created storage bucket for the user.
        def self.make_bucket(user)
          self::MUTEX.synchronize { self::BUCKET[user.id] ||= StorageBucket.new(user) }
        end

        # Remove any dead buckets. The removal threshold is one hour (3600s).
        # @return [void] this method does not return usable data for the caller.
        def self.audit_buckets
          self::MUTEX.synchronize { self::BUCKET.delete_if { |_, value| value.dead? } }
        end

        # Merge multiple logging messages sent within a short time period into one.
        # @param user [#id] the user or member to create a logging bucket for.
        # @param value [Hash] the log data such as deleted message to log.
        def self.debounced_logger(user, value)
          self::MUTEX.synchronize do
            # Add the log message to the user's log stash.
            self::LOGGER[user.id] << value

            # If a debounce is already in progress, don't start another.
            self::LOGGER[user.id].bounced? ? return : self::LOGGER[user.id].bounced = true
          end

          # Remove the entry entirely, since the user usually gets banned.
          sleep(66) && self::MUTEX.synchronize { logger(user, self::LOGGER.delete(user.id)) }
        end
      end
    end
  end
end
