# frozen_string_literal: true

module Birthdays
  # A guild which has enabled birthday perks.
  class Guild
    # @return [Integer] the snowflake ID of the guild.
    attr_reader :id

    # @return [Integer] the snowflake ID of the guild's birthday role.
    attr_reader :role_id

    # @return [Integer] the UNIX timestamp of when this guild was setup.
    attr_reader :setup_at

    # @return [Integer] the snowflake ID of the user that setup this guild.
    attr_reader :setup_by

    # @return [Integer, nil] the snowflake ID of the guild's annoucement channel.
    attr_reader :channel_id

    # @return [Sequel::Dataset]
    DB = POSTGRES[:birthday_settings]

    # @!visibility private
    def initialize(state)
      update_state(state)
    end

    # Check if this guild's role was deleted.
    # @return [Boolean] Whether the role was deleted.
    def role_deleted?
      BOT.server(@id)&.role(@role_id).nil?
    end

    # Get metadata about the settings for this guild.
    # @return [Array(String, Integer)] Metadata info about this guild.
    def view
      [BOT.user(@setup_by)&.name, @setup_at]
    end

    # Delete the record for this guild.
    # @note Ensure we manually remove the guild from the user's guilds.
    def delete
      delete_users = <<~SQL
        UPDATE user_birthdays SET guilds =
        array_remove(guilds, ?) WHERE ? = ANY(guilds);
      SQL

      POSTGRES.transaction do
        # Delete the settings record from the database.
        DB.where(guild_id: @id).delete

        # Filter and remove the guild from the guilds array.
        POSTGRES[delete_users, @id, @id]
      end
    end

    # Update the properties of this guild.
    # @param role_id [Integer] The ID of the birthday role for this guild.
    # @param channel_id [Integer, nil] The ID of the announcement channel for this guild.
    def edit(**rest)
      rest = {
        role_id: rest[:role_id],
        channel_id: rest[:channel_id]
      }

      update_state(DB.where(guild_id: @id).returning.update(**rest.compact).first)
    end

    # @!visibility private
    def self.create(...)
      Storage.pool.create_guild(...)
    end

    # @!visibility private
    def self.delete(data)
      Storage.pool.delete_guild(guild_id: data.server.id)
    end

    # @!visibility private
    def self.get(data, hit: false)
      Storage.pool.guild(guild_id: data.server.id, hit: hit)
    end

    private

    # @!visibility private
    def update_state(new_data)
      @id = new_data[:guild_id]
      @role_id = new_data[:role_id]
      @setup_at = new_data[:setup_at]
      @setup_by = new_data[:setup_by]
      @channel_id = new_data[:channel_id]
    end
  end

  # Represents a single birthday record for a user.
  class Member
    # @return [Integer] the snowflake ID of the user.
    attr_reader :id

    # @return [Array<Integer>] the user's synced guilds.
    attr_reader :guilds

    # @return [Time, nil] the birthday as a UTC timestamp.
    attr_reader :birthday

    # @return [Sequel::Dataset]
    DB = POSTGRES[:user_birthdays]

    # @!visibility private
    def initialize(data)
      @id = data.user.id
      model = get_user(@id)
      @guilds = model[:guilds]
      @guild_id = data.server.id
      @birthday = model[:birthdate]
    end

    # Check if this user is a dummy user.
    # @return [Boolean] whether or not the user is a dummy user.
    def blank?
      @birthday.nil?
    end

    # Check if the guild this user was created in is synced.
    # @return [Boolean] whether or not the user's guild is synced.
    def synced?
      @guilds.include?(@guild_id)
    end

    # Delete the record for this user.
    def delete
      DB.where(user_id: @id).delete
    end

    # Get the guild the user was created in.
    # @return [Guild, nil] the guild the user was created in.
    def guild
      Storage.pool.guild(guild_id: @guild_id)
    end

    # Set the user's birthdate.
    # @param birthday [Time] the birthdate to set for the user.
    def birthday=(birthday)
      conflict = {
        target: :user_id,
        update: { birthdate: birthday.utc }
      }

      rest = {
        user_id: @id,
        birthdate: birthday.utc,
        guilds: Sequel.pg_array([@guild_id])
      }

      DB.insert_conflict(**conflict).insert(**rest)
    end

    # Add the guild this user was created into the user's guilds array.
    def sync
      DB.where(user_id: @id).update(guilds: Sequel.lit("array_append(guilds, ?)", @guild_id))
    end

    # Remove the guild this user was created into the user's guilds array.
    def desync
      DB.where(user_id: @id).update(guilds: Sequel.lit("array_remove(guilds, ?)", @guild_id))
    end

    private

    # @!visibility private
    def get_user(user_id)
      DB.where(user_id: user_id).first || {}
    end
  end

  # Information about a user in the backend.
  class User
    # @return [Integer]
    attr_reader :user_id
    alias resolve_id user_id

    # @return [DateTime]
    attr_reader :birthdate

    # @return [Sequel::Dataset]
    DB = POSTGRES[:user_birthdays]

    # @!visibility private
    def initialize(data)
      @user_id = data[:user_id]
      @birthdate = data[:birthdate]
    end

    # Set the pending state for the member.
    # @param pending [true, false] if the member is pending or not.
    def pending=(pending)
      DB.where(user_id: user_id).update(pending: pending)
    end

    # Send the birthday message to a channel for a guild.
    # @param guild [Guild] The guild to send the message to.
    def send_message(guild)
      message = ::AdminCommands::Birthdays::RESPONSE[1] % user_id

      BOT.channel(guild.channel_id)&.send_message(message) rescue nil
    end

    # Add the birthday role to a member for a guild.
    # @param guild [Guild] The guild to add the role for.
    def add_role(guild)
      BOT.member(guild.id, user_id)&.add_role(guild.role_id) rescue nil
    end

    # Remove the birthday role from a member for a guild.
    # @param guild [Guild] The guild to remove the role for.
    def remove_role(guild)
      BOT.member(guild.id, user_id)&.remove_role(guild.role_id) rescue nil
    end

    # Get the time at which the member's birthday occured this year.
    # @return [Time] The time at when the birthday occured this year.
    def this_birthdate
      Time.utc(*birthdate.to_a.tap { it[5] = Time.now.utc.year })
    end

    # Get the member's birthdate but for the next calender year.
    # @return [Time] The time at when the birthday will occur next year.
    def next_birthdate
      Time.utc(*birthdate.to_a.tap { it[5] = Time.now.utc.year + 1 })
    end

    # Get the next time the member's birthday will occur.
    # @return [Time] The next time the member's birthday will occur.
    def next_birthday
      time = Time.utc(*birthdate.to_a.tap { it[5] = Time.now.utc.year })

      Time.now.utc.to_date > time.utc.to_date ? next_birthdate : time
    end

    # Get a list of guilds that the member has synced to their account.
    # @return [Array<Guild>] Guilds the member is a part of currently.
    def guilds
      (DB.where(user_id:).select(:guilds).first || {})[:guilds]&.filter_map do |id|
        Storage.guild(guild_id: id, hit: true)
      end
    end
  end
end
