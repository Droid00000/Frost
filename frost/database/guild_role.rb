# frozen_string_literal: true

module Frost
  # Represents a roles DB.
  class Roles
    # Easy way to access the DB.
    @@pg = POSTGRES[:event_settings]

    # Modify the icon settings for a role.
    def self.icon(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id, role_id: data.options["role"]).update(guild_icon: data.options["icon"])
      end
    end

    # Add a new role to the database.
    def self.add(data)
      POSTGRES.transaction do
        @@pg.insert(guild_id: data.server.id, role_id: data.options["role"], guild_icon: data.options["icon"])
      end
    end

    # Gets all the setup roles for a guild.
    def self.all(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id).select(:role_id)&.map { |role| "<@&#{role[:role_id]}>" }
      end
    end

    # Get the icon settings for a role.
    def self.any_icon?(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id, role_id: data.options["role"]).get(:guild_icon)
      end
    end

    # Check if an existing role is setup.
    def self.get?(data)
      POSTGRES.transaction do
        !@@pg.where(guild_id: data.server.id, role_id: data.options["role"]).empty?
      end
    end

    # Remove a single role from the DB.
    def self.remove(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id, role_id: data.options["role"]).delete
      end
    end

    # Removes all instances of this role.
    def self.remove_role(data)
      POSTGRES.transaction do
        @@pg.where(role_id: data.id, guild_id: data.server.id).delete
      end
    end

    # Check if this guild is enable.
    def self.enabled?(data)
      POSTGRES.transaction do
        !@@pg.where(guild_id: data.server.id).empty?
      end
    end

    # Removes all the roles for a guild.
    def self.disable(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id).delete
      end
    end
  end
end
