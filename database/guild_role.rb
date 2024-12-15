# frozen_string_literal: true

module Frost
  # Represents a roles DB.
  class Roles
    # Easy way to access the DB.
    attr_accessor :PG

    # @param database [Sequel::Dataset]
    def initialize
      @@PG = PG[:event_settings]
    end

    # Gets all the setup roles for a guild.
    def self.all(data)
      PG.transaction do
        @@PG.where(guild_id: data.server.id).select(:role_id)&.map { |role| "<@&#{role[:role_id]}>" }
      end
    end

    # Check if an existing role is setup.
    def self.get?(data)
      PG.transaction do
        !@@PG.where(guild_id: data.server.id, role_id: data.options['role']).empty?
      end
    end

    # Add a new role to the database.
    def self.add(data)
      PG.transaction do
        @@PG.insert(guild_id: data.server.id, role_id: data.options['role'])
      end
    end

    # Removes all the roles for a guild.
    def self.disable(data)
      PG.transaction do
        @@PG.where(guild_id: data.server.id).delete
      end
    end

    # Check if this guild is enable.
    def self.enabled?(data)
      PG.transaction do
        !@@PG.where(guild_id: data.server.id).empty?
      end
    end
  end
end
