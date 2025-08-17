# frozen_string_literal: true

module Birthdays
  # Model for a birthday server.
  class Guild
    # @return [Boolean]
    attr_reader :lazy
    alias lazy? lazy

    # @return [Integer]
    attr_reader :guild
    alias guild_id guild

    # @return [Integer]
    attr_reader :role_id
    alias role role_id

    # @return [Integer, nil]
    attr_reader :channel_id
    alias channel channel_id

    # @return [Integer, nil]
    attr_reader :enabled_at
    alias setup_at enabled_at

    # @return [Integer, nil]
    attr_reader :enabled_by
    alias setup_by enabled_by

    # @return [Sequel::Dataset]
    @@pg = POSTGRES[:birthday_settings]

    # @return [Sequel::Dataset]
    @@users = POSTGRES[:user_birthdays]

    # @!visibility private
    def initialize(data, **rest)
      @bot = data.bot
      @lazy = rest[:lazy]
      @guild = data.server.id
      model = find_guild(**rest)
      @role_id = model[:role_id]
      @enabled_by = model[:setup_by]
      @enabled_at = model[:setup_at]
      @channel_id = model[:channel_id]
    end

    # Check if this guild is nil, e.g. hasn't been setup.
    # @return [Boolean] Whether this guild is nil or not.
    def blank? = role_id.nil?

    # Get metadata about the settings for this birthday guild.
    # @return [Array<String, Integer>] Metadata info about this guild.
    def view = [@bot.user(enabled_by)&.name, enabled_at]

    # Create a new record or update an existing record.
    # @param guild_id [Integer] ID of the guild this record is for.
    # @param role_id [Integer] ID of the birthday role for this guild.
    # @param channel_id [Integer] ID of the birthday annoucement channel for this guild.
    # @param setup_by [Integer] ID of the user who setup birthday events for this guild.
    # @param setup_at [Integer] Unix timestamp of when birthday events were setup for this guild.
    def edit(**options)
      POSTGRES.transaction do
        options = options.slice(:role_id, :channel_id) unless blank?

        blank? ? @@pg.insert(**options) : @@pg.where(guild_id: guild).update(options)
      end
    end

    # Delete the record for this guild.
    # @note This method takes arguments, but they're ignored.
    def delete(**)
      query = <<~SQL
        UPDATE user_birthdays SET guilds =
        array_remove(guilds, ?) WHERE ? = ANY(guilds);
      SQL

      POSTGRES.transaction do
        # Delete the settings record from the database.
        @@pg.where(guild_id: guild).delete

        # Filter and remove the guild from the guilds array.
        POSTGRES[query, guild_id, guild_id]
      end
    end

    private

    # @!visibility private
    def find_guild(**options)
      @lazy ? options : POSTGRES.transaction { @@pg.where(guild_id: @guild).first } || options
    end
  end

  # Represents a single birthday record for a user.
  class Member
    # @return [Integer]
    attr_reader :user_id

    # @return [Integer]
    attr_reader :guild_id

    # @return [Time, nil]
    attr_reader :birthday

    # @return [Array<Integer>]
    attr_reader :user_guilds

    # @return [Sequel::Dataset]
    @@pg = POSTGRES[:user_birthdays]

    # @!visibility private
    def initialize(data, **rest)
      @data = data
      @lazy = rest[:lazy]
      @user_id = data.user.id
      @guild_id = data.server.id
      model = find_user(@user_id)
      @birthday = model[:birthdate]
      @user_guilds = model[:guilds]
    end

    # Check if this member is nil, e.g. doesn't have a record.
    # @return [true, false] Whether the member itself is blank.
    def blank? = birthday.nil?

    # Get the birthday guild this member is a part of.
    # @return [Guild] The birthday guild this member is part of.
    def guild = @guild ||= Guild.new(@data)

    # Check if this guild is synced into the user's guilds array.
    # @return [true, false] Whether this guild is synced or not.
    def synced? = user_guilds.any?(guild_id)

    # Remove this members birthday records for every guild.
    def delete
      POSTGRES.transaction { @@pg.where(user_id: user_id).delete }
    end

    # Set the birthday and inital state for the user.
    def birthday=(birthday)
      POSTGRES.transaction do
        @@pg.insert_conflict(**on_conflict(birthday.utc)).insert(**on_insert(birthday.utc))
      end
    end

    # Un-sync the guild from the user's guild's array.
    def desync
      POSTGRES.transaction do
        @@pg.where(user_id: user_id).update(guilds: Sequel.function(:array_remove, :guilds, guild_id))
      end
    end

    # Sync the guild into the user's guild's array.
    def sync
      POSTGRES.transaction do
        @@pg.where(user_id: user_id).update(guilds: Sequel.function(:array_append, :guilds, guild_id))
      end
    end

    private

    # @!visibility private
    def on_conflict(*options)
      { target: :user_id, update: { birthdate: options.first } }
    end

    # @!visibility private
    def find_user(*options)
      POSTGRES.transaction { @@pg.where(user_id: options.first).first } || {}
    end

    # @!visibility private
    def on_insert(*options)
      { user_id: user_id, guilds: Sequel.pg_array([guild_id]), birthdate: options[0] }
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
    @@pg = POSTGRES[:user_birthdays]

    # Lightweight struct for guilds.
    Guild = Struct.new(:id, :role, :channel)

    # @!visibility private
    def initialize(data)
      @user_id = data[:user_id]
      @birthdate = data[:birthdate]
    end

    # Set the pending state for the member.
    # @param pending [true, false] if the member is pending or not.
    def pending=(pending)
      POSTGRES.transaction do
        @@pg.where(user_id: user_id).update(pending: pending)
      end
    end

    # Send the birthday message to a channel for a guild.
    # @param guild [Guild] The guild to send the message to.
    def send_message(guild)
      message = ::AdminCommands::Birthdays::RESPONSE[1] % user_id

      BOT.channel(guild.channel)&.send_message(message) rescue nil
    end

    # Add the birthday role to a member for a guild.
    # @param guild [Guild] The guild to add the role for.
    def add_role(guild)
      BOT.member(guild.id, user_id)&.add_role(guild.role) rescue nil
    end

    # Remove the birthday role from a member for a guild.
    # @param guild [Guild] The guild to remove the role for.
    def remove_role(guild)
      BOT.member(guild.id, user_id)&.remove_role(guild.role) rescue nil
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
      query = <<~SQL
        SELECT DISTINCT * FROM birthday_settings WHERE guild_id =
        ANY(ARRAY(SELECT guilds FROM user_birthdays WHERE user_id = ?));
      SQL

      POSTGRES.transaction do
        POSTGRES[query, user_id].all.map do |model|
          Guild.new(model[:guild_id], model[:role_id], model[:channel_id])
        end
      end
    end
  end
end
