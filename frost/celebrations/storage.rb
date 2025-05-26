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
    def delete(**_options)
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
end
