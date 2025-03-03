# frozen_string_literal: true

module Frost
  # Represents a birthday DB.
  class Birthdays
    # Default timezones used.
    DEFAULT_ZONES = {
      "New York, United States": "America/New_York",
      "Los Angeles, United States": "America/Los_Angeles",
      "Chicago, United States": "America/Chicago",
      "Denver, United States": "America/Denver",
      "Kolkata, India": "Asia/Kolkata",
      "Istanbul, Türkiye": "Europe/Istanbul",
      "Moscow, Russia": "Europe/Moscow",
      "London, United Kingdom": "Europe/London",
      "Paris, France": "Europe/Paris",
      "Madrid, Spain": "Europe/Madrid",
      "Berlin, Germany": "Europe/Berlin",
      "Athens, Greece": "Europe/Athens",
      "Kyiv, Ukraine": "Europe/Kyiv",
      "Rome, Italy": "Europe/Rome",
      "Amsterdam, Netherlands": "Europe/Amsterdam",
      "Warsaw, Poland": "Europe/Warsaw",
      "Toronto, Canada": "America/Toronto",
      "Brisbane, Australia": "Australia/Brisbane",
      "Sydney, Australia": "Australia/Sydney",
      "Melbourne, Australia": "Australia/Melbourne",
      "São Paulo, Brazil": "America/Sao_Paulo",
      "Tokyo, Japan": "Asia/Tokyo",
      "Shanghai, China": "Asia/Shanghai",
      "Lagos, Nigeria": "Africa/Lagos"
    }.freeze

    # Easy way to access the DB.
    @@pg = POSTGRES[:guild_birthdays]

    # Easy way to access timezones.
    @@zones = POSTGRES[:guild_timezones]

    # Search for a specific timezone entry from the DB.
    def self.search(query)
      POSTGRES.transaction do
        @@zones.where { (Sequel.lit("name % ?", query)) | (Sequel.lit("timezone % ?", query)) | (Sequel.lit("country % ?", query)) }.limit(25)
      end
    end

    # Edit an existing birthday in the DB.
    def self.edit(*data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data[0].server.id, user_id: data[0].user.id).update(**data[1])
      end
    end

    # Get a user from the DB.
    def self.user(*data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data[0].server.id, user_id: data[0].user.id).get(data[1])
      end
    end

    # Check if a user exists in the DB.
    def self.user?(data)
      POSTGRES.transaction do
        !@@pg.where(guild_id: data.server.id, user_id: data.user.id).empty?
      end
    end

    # Delete the birthday of a user.
    def self.delete(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id, user_id: data.user.id).delete
      end
    end

    # Mark a member as having a birthday role.
    def self.mark(*data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data[0], user_id: data[1]).update(active: true)
      end
    end

    # Unmark a member from having the birthday role.
    def self.unmark(*data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data[0], user_id: data[1]).update(active: false)
      end
    end

    # Delete all the birthdays for this server.
    def self.prune(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id).delete
      end
    end

    # Check birthdays for this timezone.
    def self.zone(zone)
      POSTGRES.transaction do
        !@@pg.where(timezone: zone).empty?
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

    # Returns all birthdays.
    def self.drain
      @@pg
    end

    # Represents a birthday settings DB.
    class Settings
      # Easy way to access the DB.
      @@pg = POSTGRES[:birthday_settings]

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

      # Get the role from the DB.
      def self.fetch_role(data)
        POSTGRES.transaction do
          @@pg.where(guild_id: data).get(:role_id)
        end
      end

      # Insert a new birthday into the DB.
      def self.setup(data)
        POSTGRES.transaction do
          @@pg.insert(**data)
        end
      end
    end
  end
end
