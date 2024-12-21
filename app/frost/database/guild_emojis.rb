# frozen_string_literal: true

module Frost
  # Represents an emojis DB.
  class Emojis
    # Easy way to access emojis.
    @@emojis = []

    # Easy way to access the DB.
    @@pg = POSTGRES[:emoji_tracker]

    # @param emoji [Discordrb::Emoji]
    # @param guild [Discordrb::Server]
    def initialize(emoji, guild)
      @@emojis << { emoji: emoji, guild: guild }
    end

    # Insert a new emoji into the DB.
    def self.add(emoji, guild)
      POSTGRES.transaction do
        @@pg.insert_conflict(set: { balance: Sequel[:balance] + 1 } ).insert(emoji_id: emoji.id, guild_id: guild.id)
      end
    end

    # @param data [Discordrb::Interaction]
    def self.any?(data)
      !@@pg.where(guild_id: data.server.id).empty?
    end

    # Returns the top 15 emojis.
    def self.top(data)
      @@pg.where(guild_id: data.server.id).order(Sequel.desc(:balance)).limit(15)
    end

    # Returns the bottom 15 emojis.
    def self.bottom(data)
      @@pg.where(guild_id: data.server.id).order(Sequel.asc(:balance)).limit(15)
    end

    # Empties out the Emoji cache.
    # @param index [Integer]
    def delete(index)
      @@emojis.delete_at(index)
    end

    # Returns all emojis.
    def self.drain
      @@emojis
    end
  end
end

