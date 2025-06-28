# frozen_string_literal: true

module Emojis
  # Represents an emojis DB.
  class Storage
    # Easy way to access emojis.
    @@emojis = []

    # Easy way to access the DB.
    @@pg = POSTGRES[:emoji_tracker]

    # Returns the most used emojis.
    def self.top(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id).order(Sequel.desc(:balance)).limit(700).select(:emoji_id, :balance)
      end
    end

    # Inserts a set of new emojis into the DB.
    def self.drain
      POSTGRES.transaction do
        # Group all duplicate emojis together and then generate a single hash.
        emojis = @@emojis.group_by(&:itself).values.map do |group|
          { balance: group.size, **group.first }
        end

        # Try to create a new record, or update the existing record for each emoji.
        @@emojis.clear if @@pg.insert_conflict(
          update: { balance: Sequel[:emoji_tracker][:balance] + Sequel[:excluded][:balance] },
          target: %i[emoji_id guild_id]
        ).multi_insert(emojis)
      end
    end

    # Add an emoji to the local cache.
    def self.add(emoji, guild)
      @@emojis << { emoji_id: emoji.id, guild_id: guild.id }
    end

    # Checks the local cache for a guild.
    def self.index?(guild)
      @@emojis.any? { |emoji| emoji[:guild_id] == guild }
    end

    # Checks if the cache is too large.
    def self.large?
      drain if @@emojis.size >= 100
    end
  end
end
