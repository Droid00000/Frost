# frozen_string_literal: true

module Frost
  # Represents an emojis DB.
  class Emojis
    # Easy way to access the DB.
    attr_accessor :pg

    # Easy way to access emojis.
    attr_accessor :emojis

    # @param database [Sequel::Dataset]
    def initialize
      @@pg = POSTGRES[:emoji_tracker]
      @@emoji = []
    end

    # Insert a new emoji into the DB.
    def self.produce(data, index)
      POSTGRES.transaction do
        if @@pg.where(emoji_id: data[:emoji].id, guild_id: data[:guild].id).empty?
          @@pg.insert(emoji_id: data[:emoji].id, guild_id: data[:guild].id)
        else
          @@pg.where(emoji_id: data[:emoji].id, guild_id: data[:guild].id).update(balance(Sequel[:balance] + 1))
        end
        delete(index)
      end
    end

    # @param emoji [Discordrb::Emoji]
    # @param guild [Discordrb::Server]
    def self.emoji(emoji, guild)
      @@emoji << { emoji: emoji, guild: guild }
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
      @@emoji.delete_at(index)
    end

    # Returns all emojis.
    def self.drain
      @@emoji
    end
  end
end
