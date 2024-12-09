# frozen_string_literal: true

module Frost
  # Represents an emojis DB.
  class Emojis
    # Easy way to access the DB.
    attr_accessor :PG

    # @param database [Sequel::Dataset]
    def initialize(database)
      @@PG = POSTGRES[:emoji_tracker]
    end

    # Add a new role to the database.
    def self.add(data)
      @@PG.insert(emoji_id: data.emoji.id, guild_id: data.server.id)
    end
  end
end
