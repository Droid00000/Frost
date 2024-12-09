# frozen_string_literal: true

module Frost
  # Represents a settings DB
  class Settings
    # Easy way to access the DB.
    attr_accessor :PG

    # @param database [Sequel::Dataset]
    def initialize(database)
      @@PG = database
    end

    # Gets the hoist role for this guild.
    def self.get(data)
      POSTGRES.transaction do
        @@PG.where(guild_id: data.server.id).get(:hoist_role)
      end
    end

    # Update a hoist role for this guild.
    def self.update(data)
      POSTGRES.transaction do
        @@PG.where(guild_id: data.server.id).update(hoist_role: data.options['role'])
      end
    end

    # Removes a hoist role for this guild.
    def self.remove(data)
      POSTGRES.transaction do
        @@PG.where(guild_id: data.server.id).delete
      end
    end

    # Adds a hoist role for this guild.
    def self.add(data)
      POSTGRES.transaction do
        @@PG.insert(guild_id: data.server.id, hoist_role: data.options['role'])
      end
    end
  end
end
