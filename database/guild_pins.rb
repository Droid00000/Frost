# frozen_string_literal: true

module Frost
  # Represents a pins DB.
  class Pins
    # Easy way to access the DB.
    attr_accessor :PG

    # @param database [Sequel::Dataset]
    def initialize
      @@PG = PG[:archiver_settings]
    end

    # Updates an existing archive channel.
    def self.update(data)
      PG.transaction do
        @@PG.where(guild_id: data.server.id).update(channel_id: data.options['channel'])
      end
    end

    # Sets up an existing archive channel.
    def self.setup(data)
      PG.transaction do
        @@PG.insert(guild_id: data.server.id, channel_id: data.options['channel'])
      end
    end

    # Gets an existing archive channel.
    def self.get(data)
      PG.transaction do
        @@PG.where(guild_id: data.server.id).get(:channel_id)
      end
    end

    # Checks if there's an existing archive channel.
    def self.get?(data)
      PG.transaction do
        !@@PG.where(guild_id: data.server.id).empty?
      end
    end

    # Deletes an existing archive channel.
    def self.disable(data)
      PG.transaction do
        @@PG.where(guild_id: data.server.id).delete
      end
    end
  end
end
