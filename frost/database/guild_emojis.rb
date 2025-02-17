# frozen_string_literal: true

module Frost
  # Represents an emojis DB.
  class Emojis
    # Easy way to access emojis.
    @@emojis = []

    # Returns all emojis.
    def self.drain; @@emojis; end

    # Easy way to access the DB.
    @@pg = POSTGRES[:emoji_tracker]

    # Prune un-used emojis from the DB.
    def self.prune(range)
      range.to_a.each do |number|
        POSTGRES.transaction do
          @@pg.where(balance: number).delete
        end
      end
    end

    # @param emoji [Discordrb::Emoji]
    # @param guild [Discordrb::Server]
    def initialize(emoji, guild)
      @@emojis << { emoji: emoji, guild: guild }
    end

    # @param data [Discordrb::Interaction]
    def self.any?(data)
      POSTGRES.transaction do
        !@@pg.where(guild_id: data.server.id).empty?
      end
    end

    # Insert a new emoji into the DB.
    def self.add(emoji, guild)
      POSTGRES.transaction do
        @@pg.insert(emoji_id: emoji.id, guild_id: guild.id)
      end
    end

    # Returns the top 15 emojis.
    def self.top(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id).order(Sequel.desc(:balance)).limit(15)
      end
    end
  end
end
