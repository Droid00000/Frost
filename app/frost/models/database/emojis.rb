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

    # Add a new role to the database.
    def self.add(data)
      POSTGRES.transaction do
        @@PG.insert(emoji_id: data.emoji.id, guild_id: data.server.id)
      end
    end

    # @param emoji [Discordrb::Emoji]
    # @param server [Discordrb::Server]
    def self.add(emoji, server)
      @@emoji << { emoji: emoji, server: server }
    end

    # Returns all emojis.
    def self.get_emojis
      @@emoji
    end
  end
end
