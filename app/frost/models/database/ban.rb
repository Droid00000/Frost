# frozen_string_literal: true

module Frost
  # Represents a ban DB.
  class Ban
    # Easy way to access the DB.
    attr_accessor :PG

    # @param database [Sequel::Dataset]
    def initialize(database)
      @@PG = database
    end

    # Removes a ban from the DB.
    def self.remove(data)
      POSTGRES.transaction do
        @@PG.where(guild_id: data.server.id, user_id: data.options['user']).delete
      end
    end

    # Checks if a user is in the DB.
    def self.user?(data)
      POSTGRES.transaction do
        !@@PG.where(guild_id: data.server.id, user_id: data.user.id).empty?
      end
    end

    # Adds a new user to the DB.
    def self.add(data)
      POSTGRES.transaction do
        @@PG.insert(guild_id: data.server.id, user_id: data.options['user'])
      end
    end
  end
end
