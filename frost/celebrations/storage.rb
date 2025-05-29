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
    @@users = POSTGRES[:guild_birthdays]

    # @!visibility private
    def initialize(data, lazy: false)
      @bot = data.bot
      @lazy = lazy == true
      @guild = data.server.id
      @model = find_guild(@guild)
      @role_id = @model[:role_id]
      @enabled_by = @model[:setup_by]
      @enabled_at = @model[:setup_at]
      @channel_id = @model[:channel_id]
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
      POSGTRES.transaction do
        @@pg.where(guild_id: guild).delete

        @@users.where(guild_id: [guild]).delete
      end
    end

    private

    # @!visibility private
    def find_guild(*_options)
      lazy ? {} : POSTGRES.transaction { @@pg.where(guild_id: @guild).first } || {}
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
    alias guilds user_guilds

    # @return [Sequel::Dataset]
    @@pg = POSTGRES[:guild_birthdays]

    # @!visibility private
    def initialize(data, lazy: false)
      @data = data
      @lazy = lazy == true
      @user_id = data.user.id
      @guild_id = data.server.id
      @model = find_user(@user_id)
      @birthday = @model[:birthday]
      @user_guilds = @model[:guilds]
    end

    # Check if this member is nil, e.g. doesn't have a record.
    # @return [true, false] Whether the member itself is blank.
    def blank? = birthday.nil?

    # Get the birthday guild this member is a part of.
    # @return [Guild] The birthday guild this member is part of.
    def guild = @guild ||= Guild.new(@data)

    # Check if this guild is synced into the user's guilds array.
    # @return [true, false] Whether this guild is synced or not.
    def synced? = user_guilds.to_a.any?(guild_id)

    # Remove this members birthday records for every guild.
    def delete
      POSTGRES.transaction { @@pg.where(user_id: user_id).delete }
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
  end
end
