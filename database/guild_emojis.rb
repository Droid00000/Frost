# frozen_string_literal: true

module Frost
  # Represents an emojis DB.
  class Emojis
    # Easy way to access the DB.
    attr_accessor :PG

    # Easy way to access emojis.
    attr_accessor :emojis

    # @param database [Sequel::Dataset]
    def initialize
      @@emoji = []
      @@PG = PG[:emoji_tracker]
    end

    # Insert a new emoji into the DB.
    def self.add(data)
      PG.transaction do
        if @@PG.where(emoji_id: data[:emoji].id, guild_id: data[:guild].id).empty?
          @@PG.insert(emoji_id: data[:emoji].id, guild_id: data[:guild].id)
        else
          @@PG.where(emoji_id: data[:emoji].id, guild_id: data[:guild].id).update(balance Sequel[:balance] + 1)
        end
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
