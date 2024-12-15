# frozen_string_literal: true

module Frost
  module Boosters
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

      # Manually adds a user to the database.
      def self.create(data)
        POSTGRES.transaction do
          @@PG.insert(guild_id: data.server.id, user_id: data.options['user'], role_id: data.options['role'])
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
      def self.user?(data, hash = false)
        POSTGRES.transaction do
          if hash == true
            !@@PG.where(guild_id: data.server.id, user_id: data.options['user']).empty?
          else
            !@@PG.where(guild_id: data.server.id, user_id: data.user.id).empty?
          end
        end
      end
    end

    # Represents a settings DB
    class Settings
      # Easy way to access the DB.
      attr_accessor :PG

      # @param database [Sequel::Dataset]
      def initialize(database)
        @@PG = POSTGRES[:booster_settings]
      end

      # Gets the hoist role for this guild.
      def self.get(data)
        POSTGRES.transaction do
          @@PG.where(guild_id: data.server.id).get(:hoist_role)
        end
      end

      # Gets the hoist role for this guild.
      def self.get?(data)
        POSTGRES.transaction do
          !@@PG.where(guild_id: data.server.id).get(:hoist_role).nil?
        end
      end

      # Update a hoist role for this guild.
      def self.update(data)
        POSTGRES.transaction do
          @@PG.where(guild_id: data.server.id).update(hoist_role: data.options['role'])
        end
      end

      # Removes a hoist role for this guild.
      def self.disable(data)
        POSTGRES.transaction do
          @@PG.where(guild_id: data.server.id).delete
        end
      end

      # Adds a hoist role for this guild.
      def self.setup(data)
        POSTGRES.transaction do
          @@PG.insert(guild_id: data.server.id, hoist_role: data.options['role'])
        end
      end
    end

    class Ban
      # Easy way to access the DB.
      attr_accessor :PG

      # @param database [Sequel::Dataset]
      def initialize(database)
        @@PG = POSTGRES[:banned_boosters]
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

      # Checks if a member is banned.
      def self.ensure?(data)
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
end
