# frozen_string_literal: true

module Frost
  module Booster
    # Represents a boosters DB.
    class Members
      # Easy way to access the DB.
      attr_accessor :PG
      alias_method :all, :PG

      # @param database [Sequel::Dataset]
      def initialize(database)
        @@PG = POSTGRES[:server_boosters]
      end

      # Adds a booster to the DB.
      def self.add(data, role)
        POSTGRES.transaction do
          @@PG.insert(guild_id: data.server.id, user_id: data.user.id, role_id: role.id)
        end
      end

      # Gets the role of a booster.
      def self.role(data)
        POSTGRES.transaction do
          @@PG.where(guild_id: data.server.id, user_id: data.user.id).get(:role_id)
        end
      end

      # Removes all instances of a role from the DB.
      def self.purge(data)
        POSTGRES.transaction do
          @@PG.where(guild_id: data.server.id, role_id: data.options['role']).delete
        end
      end

      # Removes a single user from the DB.
      def self.delete(data)
        POSTGRES.transaction do
          @@PG.where(guild_id: data.server.id, user_id: data.user.id).delete
        end
      end

      # Checks if a user is in the DB.
      def self.user?(data)
        POSTGRES.transaction do
          !@@PG.where(guild_id: data.server.id, user_id: data.user.id).empty?
        end
      end
    end
  end
end
