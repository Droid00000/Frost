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
    end
  end
end
