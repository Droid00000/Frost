# frozen_string_literal: true

module Frost
  # Represents an emojis DB.
  class Emojis
    # Easy way to access the DB.
    attr_accessor :PG

    # Easy way to access emojis.
    attr_accessor :emojis

    # @param database [Sequel::Dataset]
    def initialize(database)
      @@emoji = []
      @@PG = POSTGRES[:emoji_tracker]
    end

    # Insert a new emoji into the DB.
    def self.add(data)
      POSTGRES.transaction do
        @@PG.insert(emoji_id: data[:emoji].id, guild_id: data[:guild].id)
      end
    end

    # @param emoji [Discordrb::Emoji]
    # @param guild [Discordrb::Server]
    def self.emoji(emoji, guild)
      @@emoji << { emoji: emoji, guild: guild }
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
