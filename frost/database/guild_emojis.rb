# frozen_string_literal: true

module Frost
  # Represents an emojis DB.
  class Emojis
    # Easy way to access emojis.
    @@emojis = []

    # Easy way to access the DB.
    @@pg = POSTGRES[:emoji_tracker]

    # Returns the top 15 emojis.
    def self.top(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id).order(Sequel.desc(:balance)).limit(15)
      end
    end

    # @param emoji [Discordrb::Emoji]
    # @param guild [Discordrb::Server]
    def initialize(emoji, guild)
      @@emojis << { emoji_id: emoji.id, guild_id: guild.id }
    end

    # @param data [Discordrb::Interaction]
    def self.count(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id).size.delimit
      end
    end

    # Insert a new emoji into the DB.
    def self.drain
      POSTGRES.transaction do
        @@emojis.clear if @@pg.multi_insert(@@emojis)
      end
    end

    # @param data [Discordrb::Interaction]
    def self.any?(data)
      POSTGRES.transaction do
        !@@pg.where(guild_id: data.server.id).empty?
      end
    end

    # Prune un-used emojis from the DB.
    def self.prune
      POSTGRES.transaction do
        @@pg.where("balance < 3").delete
      end
    end
  end
end
