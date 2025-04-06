# frozen_string_literal: true

module Frost
  # Represents a birthday DB.
  class Birthdays
    # Easy way to access the DB.
    @@pg = POSTGRES[:guild_birthdays]

    # Returns all birthdays.
    def self.drain = @@pg

    # Delete all the birthdays for this server.
    def self.prune(data)
      POSTGRES.transaction do
        @@pg.where{ guild_ids @> data.server.id }.update(guild_ids: Sequel.function(:array_remove, :guild_ids, data.server.id))
      end
    end

    # Add this server to a memeber.
    def self.sync(data)
      POSTGRES.transaction do
        @@pg.where(user_id: data.user.id).update(guild_ids: Sequel.function(:array_append, :guild_ids, data.server.id))
      end
    end

    # Search for a specific timezone entry from the DB.
    def self.search(query)
      POSTGRES.transaction do
        POSTGRES["SELECT * FROM search_timezones(?);", query].all
      end
    end

    # Edit an existing birthday in the DB.
    def self.edit(*data)
      POSTGRES.transaction do
        @@pg.where(user_id: data[0].user.id).update(**data[1])
      end
    end

    # Unmark a member from having the birthday role.
    def self.unmark(*data)
      POSTGRES.transaction do
        @@pg.where(user_id: data[1]).update(active: false)
      end
    end

    # Mark a member as having a birthday role.
    def self.mark(*data)
      POSTGRES.transaction do
        @@pg.where(user_id: data[1]).update(active: true)
      end
    end

    # Fetch a user from the DB.
    def self.fetch(data)
      POSTGRES.transaction do
        @@pg.where(user_id: data.user.id).get(:birthday)
      end
    end

    # Check if a user exists in the DB.
    def self.user?(data)
      POSTGRES.transaction do
        !@@pg.where(user_id: data.user.id).empty?
      end
    end

    # Delete the birthday of a user.
    def self.delete(data)
      POSTGRES.transaction do
        @@pg.where(user_id: data.user.id).delete
      end
    end

    # Get a user from the DB.
    def self.user(data)
      POSTGRES.transaction do
        @@pg.where(user_id: data.user.id).first
      end
    end

    # Get all the marked members from the database.
    def self.marked
      POSTGRES.transaction do
        @@pg.where(active: true)
      end
    end

    # Insert a new birthday into the DB.
    def self.add(data)
      POSTGRES.transaction do
        @@pg.insert(**data)
      end
    end

    # Represents a birthday settings DB.
    class Settings
      # Easy way to access the DB.
      @@pg = POSTGRES[:birthday_settings]

      # Insert a new birthday into the DB.
      def self.setup(data)
        POSTGRES.transaction do
          @@pg.insert_conflict(target: :guild_id, update: data.except(:guild_id, :setup_at, :setup_by)).insert(**data)
        end
      end

      # Removes an instance of a  channel from the DB.
      def self.remove_channel(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id, channel_id: data.id).update(channel_id: nil)
        end
      end

      # Removes all instances of this role.
      def self.remove(data)
        POSTGRES.transaction do
          @@pg.where(role_id: data.id, guild_id: data.server.id).delete
        end
      end

      # Edit an existing birthday in the DB.
      def self.edit(*data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data[0].server.id).update(**data[1])
        end
      end

      # Get the role from the DB.
      def self.role(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id).get(:role_id)
        end
      end

      # Get the channel from the DB.
      def self.channel(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data).get(:channel_id)
        end
      end

      # Disable birthday perks.
      def self.disable(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id).delete
        end
      end

      # Get a settings display view.
      def self.view(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id).first
        end
      end

      # Get the role from the DB.
      def self.fetch_role(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data).get(:role_id)
        end
      end
    end
  end
end
