# frozen_string_literal: true

module Frost
  module Boosters
    # Represents a boosters DB.
    class Members
      # Easy way to access the DB.
      @@pg = POSTGRES[:server_boosters]

      # Adds a booster to the DB.
      def self.add(data, role)
        POSTGRES.transaction do
          @@pg.insert(guild_id: data.server.id, user_id: data.user.id, role_id: role.id)
        end
      end

      # Manually adds a user to the database.
      def self.manual_add(data)
        POSTGRES.transaction do
          @@pg.insert(guild_id: data.server.id, user_id: data.options["user"], role_id: data.options["role"])
        end
      end

      # Gets the role of a booster.
      def self.role(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id, user_id: data.user.id).get(:role_id)
        end
      end

      # Removes all instances of a role from the DB.
      def self.purge(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id, role_id: data.options["role"]).delete
        end
      end

      # Removes a single user from the DB.
      def self.delete(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id, user_id: data.user.id).delete
        end
      end

      # Removes a single user from the DB.
      def self.manual_delete(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id, user_id: data.options["user"]).delete
        end
      end

      # Checks if a user is in the DB.
      def self.user?(data, hash = false)
        POSTGRES.transaction do
          if hash == true
            !@@pg.where(guild_id: data.server.id, user_id: data.options["user"]).empty?
          else
            !@@pg.where(guild_id: data.server.id, user_id: data.user.id).empty?
          end
        end
      end

      # Gets all the members in a format the Discord gateway can understand.
      def self.chunks
        @@pg.all.group_by { |member| member[:guild_id] }.map do |guild, users|
          { guild_id: guild, members: users.map { |user| user[:user_id] } }
        end
      end

      # Gets all the members.
      def self.fetch
        sleep(5)
        @@pg
      end
    end

    # Represents a settings DB
    class Settings
      # Easy way to access the DB.
      @@pg = POSTGRES[:booster_settings]

      # Gets the hoist role for this guild.
      def self.get(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id).get(:hoist_role)
        end
      end

      # Gets the hoist role for this guild.
      def self.get?(data)
        POSTGRES.transaction do
          !@@pg.where(guild_id: data.server.id).get(:hoist_role).nil?
        end
      end

      # Update a hoist role for this guild.
      def self.update(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id).update(hoist_role: data.options["role"])
        end
      end

      # Removes a hoist role for this guild.
      def self.disable(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id).delete
        end
      end

      # Adds a hoist role for this guild.
      def self.setup(data)
        POSTGRES.transaction do
          @@pg.insert(guild_id: data.server.id, hoist_role: data.options["role"])
        end
      end
    end

    class Ban
      # Easy way to access the DB.
      @@pg = POSTGRES[:banned_boosters]

      # Removes a ban from the DB.
      def self.remove(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id, user_id: data.options["user"]).delete
        end
      end

      # Checks if a user is in the DB.
      def self.user?(data, hash = false)
        POSTGRES.transaction do
          if hash == false
            !@@pg.where(guild_id: data.server.id, user_id: data.user.id).empty?
          else
            !@@pg.where(guild_id: data.server.id, user_id: data.options["user"]).empty?
          end
        end
      end

      # Checks if a member is banned.
      def self.check?(data)
        POSTGRES.transaction do
          !@@pg.where(guild_id: data.server.id, user_id: data.user.id).empty?
        end
      end

      # Adds a new user to the DB.
      def self.add(data)
        POSTGRES.transaction do
          @@pg.insert(guild_id: data.server.id, user_id: data.options["user"])
        end
      end
    end
  end
end
