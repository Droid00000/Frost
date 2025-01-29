# frozen_string_literal: true

# frozen_string_literal: true

module Frost
  # Represents a birthday DB.
  class Birthdays
    # Easy way to access the DB.
    @@pg = POSTGRES[:guild_birthdays]

    # Edit an existing birthday in the DB.
    def self.edit(data, **keys)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id, user_id: data.user.id).update(@@pg.insert(**keys))
      end
    end

    # Check if a user exists in the DB.
    def self.user?(data)
      POSTGRES.transaction do
        !@@pg.where(guild_id: data.server.id, user_id: data.user.id).empty?
      end
    end

    # Get a user from the DB.
    def self.user(data, **key)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id, user_id: data.user.id).get(**key.values.first.to_sym)
      end
    end

    # Delete the birthday of a user.
    def self.delete(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id, user_id: data.user.id).delete
      end
    end

    # Delete all the birthdays for this server.
    def self.prune(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id).delete
      end
    end

    # Insert a new birthday into the DB.
    def self.add(data)
      POSTGRES.transaction do
        @@pg.insert(**data)
      end
    end

    # Returns all emojis.
    def self.drain
      @@pg
    end

    # Represents a birthday settings DB.
    class Settings
      # Easy way to access the DB.
      @@pg = POSTGRES[:guild_birthdays]

      # Edit an existing birthday in the DB.
      def self.edit(**data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data[:guild]).update(@@pg.insert(**data))
        end
      end

      # Insert a new birthday into the DB.
      def self.setup(**data)
        POSTGRES.transaction do
          @@pg.insert(**data)
        end
      end

      # Get the channel from the DB.
      def self.channel(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.id).get(:channel_id)
        end
      end

      # Disable birthday perks.
      def self.disable(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.server.id).delete
        end
      end

      # Get the role from the DB.
      def self.role(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data.id).get(:role_id)
        end
      end
    end
  end
end
