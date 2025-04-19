# frozen_string_literal: true

module Pins
  # A guild which has the pin archiver enabled.
  class Guild
    # @return [Boolean]
    attr_reader :lazy
    alias lazy? lazy

    # @return [Integer]
    attr_reader :guild
    alias guild_id guild

    # @return [Integer]
    attr_reader :channel_id
    alias channel channel_id

    # @return [Integer, nil]
    attr_reader :enabled_at
    alias setup_at enabled_at

    # @return [Integer, nil]
    attr_reader :enabled_by
    alias setup_by enabled_by

    # @return [Sequel::Dataset]
    @@pg = POSTGRES[:archiver_settings]

    # @!visibility private
    def initialize(data, lazy: false)
      @bot = data.bot
      @lazy = lazy == true
      @guild = data.server.id
      @model = find_guild(@guild)
      @channel_id = @model[:channel_id]
      @enabled_at = @model[:enabled_at]
      @enabled_by = @model[:enabled_by]
    end

    # Check if this guild is nil, e.g. hasn't been setup.
    # @return [Boolean] Whether this guild is nil or not.
    def blank? = channel_id&.nil?

    # Get metadata about the settings for this guild.
    # @return [Array<String, Integer>] Metadata info about this guild.
    def view = [enabler&.name, enabled_at]

    # Get the user who enabled this functionality in this guild.
    # @return [Discordrb::User] The user who enabled this functionality.
    def enabler = @enabler ||= @bot.user(enabled_by)

    # Create a new record or update an existing record.
    # @param guild_id [Integer] ID of the guild this record is for.
    # @param channel_id [Integer] ID of the archive channel for this guild.
    # @param setup_by [Integer] ID of the user who setup the pin archiver for this guild.
    # @param setup_at [Integer] Timestamp of when the pin archiver was setup for this guild.
    def edit(**options)
      POSTGRES.transaction do
        options = transform_options(options)

        @@pg.insert_conflict(**conflict(options)).insert(**options)
      end
    end

    # Delete the record for this guild.
    # @note This method takes arguments, but currently they're ignored.
    def delete(**_options)
      POSTGRES.transaction { @@pg.where(guild_id: @guild_id).delete }
    end

    private

    # @!visibility private
    def resolveable?(*options)
      options[0].class.name.start_with?("Discordrb")
    end

    # @!visibility private
    def transform_options(*options)
      options[0].each do |key, value|
        options[0][key] = value.resolve_id if resolveable?(value)
      end
    end

    # @!visibility private
    def find_guild(*options)
      @lazy ? {} : POSTGRES.transaction { @@pg.where(guild: options[0]).first }
    end

    # @!visibility private
    def conflict(*options)
      { target: :guild_id, update: options[0].except(:enabled_by, :enabled_at) }
    end
  end
end
