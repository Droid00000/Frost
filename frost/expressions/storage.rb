# frozen_string_literal: true

module Emojis
  # Represents an emojis DB.
  class Storage
    # Easy way to access the DB.
    @@pg = POSTGRES[:emoji_tracker]

    # Easy way to access emojis.
    @@emojis = Hash.new { |hash, key| hash[key] = Hash.new(0) }

    # Returns the most used emojis.
    def self.top(guild)
      @@pg.where(guild_id: guild.id).select(:emoji_id, :balance).order(Sequel.desc(:balance)).limit(33)
    end

    # Inserts a set of new emojis into the DB.
    def self.drain
      POSTGRES.transaction do
        # Generate a single hash for insertion.
        emojis = @@emojis.dup.flat_map do |guild_id, hash|
          hash.map { |id, balance| { emoji_id: id, guild_id: guild_id, balance: balance } }
        end

        # If there's nothing to drain, just return early.
        return unless emojis.any?

        # Try to create a new record, or update the existing record for each emoji.
        @@emojis.clear if @@pg.insert_conflict(
          update: { balance: Sequel[:emoji_tracker][:balance] + Sequel[:excluded][:balance] },
          target: %i[emoji_id guild_id]
        ).multi_insert(emojis)
      end
    end

    # Add an emoji to the local cache.
    def self.add(emoji, guild)
      @@emojis[guild.id][emoji.id] += 1
    end

    # Checks the local cache for a guild.
    def self.index?(guild)
      @@emojis[guild.id].any?
    end

    # Check if a specific guild in the cache is full.
    def self.filled?(guild)
      @@emojis[guild.id].size >= 100
    end
  end
end
