# frozen_string_literal: true

module Emojis
  # Represents an emojis DB.
  class Storage
    # Easy way to access emojis.
    @@emojis = []

    # Easy way to access the DB.
    @@pg = POSTGRES[:emoji_tracker]

    # Inserts a set of new emojis into the DB.
    def self.drain
      POSTGRES.transaction do
        @@emojis.clear if @@pg.insert_conflict({ target: %i[emoji_id guild_id], update: { balance: Sequel[:emoji_tracker][:balance] + 1 } }).multi_insert(@@emojis)
      end
    end

    # Returns the most used emojis.
    def self.top(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id).order(Sequel.desc(:balance)).limit(700).select(:emoji_id, :balance)
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
