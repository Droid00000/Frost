# frozen_string_literal: true

module Frost
  # Generic class for boosters.
  module Boosters
    # Represents a boosters DB.
    class Members
      # Easy way to access the DB.
      @@pg = POSTGRES[:guild_boosters]

      # Fetch a booster from the DB.
      def self.fetch(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id, user_id: data.options['member']).get(:role_id)
        end
      end

      # Adds a booster to the DB.
      def self.add(data, role)
        POSTGRES.transaction do
          @@pg.insert(guild_id: data.server.id, user_id: data.user.id, role_id: role.id)
        end
      end

      # Removes all instances of this role.
      def self.remove_role(data)
        POSTGRES.transaction do
          @@pg[:guild_boosters].where(role_id: data.id, guild_id: data.server.id).delete
        end
      end

      # Gets the role of a booster.
      def self.role(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id, user_id: data.user.id).get(:role_id)
        end
      end

      # Gets all the members in a format the Discord gateway can understand.
      def self.chunks
        @@pg.all.group_by { |member| member[:guild_id] }.map do |guild, users|
          { guild_id: guild, members: users.map { |user| user[:user_id] } }
        end
      end

      # Removes a single user from the DB.
      def self.delete(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id, user_id: data.user.id).delete
        end
      end

      # Removes a single user from the DB.
      def self.prune(*data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data[0], user_id: data[1]).delete
        end
      end

      # Gets all the members.
      def self.fetch
        sleep(5); @@pg
      end
    end

    class Ban
      # Easy way to access the DB.
      @@pg = POSTGRES[:banned_boosters]

      # Checks if a user is in the DB.
      def self.user?(data)
        POSTGRES.transaction do
          !@@pg.where(guild_id: data.server.id, user_id: data.user.id).empty?
        end
      end

      # Checks if a member is banned.
      def self.check?(data)
        POSTGRES.transaction do
          !@@pg.where(guild_id: data.server.id, user_id: data.user.id).empty?
        end
      end

      # Removes a ban from the DB.
      def self.remove(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id, user_id: data.options["member"]).delete
        end
      end

      # Adds a new user to the DB.
      def self.add(data)
        POSTGRES.transaction do
          @@pg.insert_conflict.insert(guild_id: data.server.id, user_id: data.options["member"])
        end
      end
    end

    # Represents a settings DB
    class Settings
      # Easy way to access the DB.
      @@pg = POSTGRES

      # Deletes all members from the database.
      def self.delete_all(data)
        POSTGRES.transaction do
          @@pg[:guild_boosters].where(guild_id: data.server.id).delete
        end
      end

      # Removes a hoist role for this guild.
      def self.disable(data)
        POSTGRES.transaction do
          @@pg[:booster_settings].where(guild_id: data.server.id).delete
        end
      end

      # Check if any role icon can be used here.
      def self.any_icon?(data)
        POSTGRES.transaction do
          @@pg[:booster_settings].where(guild_id: data.server.id).get(:guild_icon)
        end
      end

      # Gets the hoist role for this guild.
      def self.get(data)
        POSTGRES.transaction do
          @@pg[:booster_settings].where(guild_id: data.server.id).get(:hoist_role)
        end
      end

      # Removes all instances of this role.
      def self.remove_role(data)
        POSTGRES.transaction do
          @@pg[:booster_settings].where(role_id: data.id, guild_id: data.server.id).delete
        end
      end

      # Manually get a user.
      def self.get_user(data)
        POSTGRES.transaction do
          !@@pg[:guild_boosters].where(guild_id: data.server.id, user_id: data.options["member"]).empty?
        end
      end

      # Manually delete a user.
      def self.delete_user(data)
        POSTGRES.transaction do
          @@pg[:guild_boosters].where(guild_id: data.server.id, user_id: data.options["member"]).delete
        end
      end
      
      # Manually get a ban.
      def self.get_ban(data)
        POSTGRES.transaction do
          !@@pg[:banned_boosters].where(guild_id: data.server.id, user_id: data.options["member"]).empty?
        end
      end

      # Adds a hoist role and icon setting for this guild.
      def self.setup(data)
        POSTGRES.transaction do
          @@pg[:booster_settings].insert_conflict(target: :guild_id, update: data.except(:guild_id)).insert(**data)
        end
      end

      # Add a user manually.
      def self.post_user(data)
        POSTGRES.transaction do
          @@pg[:guild_boosters].insert(guild_id: data.server.id, user_id: data.options["member"], role_id: data.options["role"])
        end
      end
    end
  end
end
