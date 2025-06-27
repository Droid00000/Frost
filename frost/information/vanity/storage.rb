# frozen_string_literal: true

module Vanity
  # A guild that's enabled vanity roles.
  class Guild
    # @return [Boolean]
    attr_reader :lazy
    alias lazy? lazy

    # @return [Integer]
    attr_reader :guild
    alias guild_id guild

    # @return [Integer, nil]
    attr_reader :role_id
    alias exempt_role role_id

    # @return [Integer, nil]
    attr_reader :enabled_by
    alias setup_by enabled_by

    # @return [Integer, nil]
    attr_reader :enabled_at
    alias setup_at enabled_at

    # @return [Sequel::Dataset]
    @@pg = POSTGRES[:custom_roles]

    # @!visibility private
    def initialize(data, lazy: false)
      @bot = data.bot
      @lazy = lazy == true
      @guild = data.server.id
      model = find_guild(@guild)
      @role_id = model[:role_id]
      @enabled_by = model[:setup_by]
      @enabled_at = model[:setup_at]
    end

    # Check if this guild is nil, e.g. hasn't been setup.
    # @return [Boolean] Whether this guild is nil or not.
    def blank? = exempt_role.nil?

    # Get metadata about the settings for this guild.
    # @return [Array(String, Integer)] Metadata info about this guild.
    def view = [@bot.user(enabled_by)&.name, enabled_at]

    # Create a new record or update an existing record.
    # @param guild_id [Integer] ID of the guild this record is for.
    # @param role_id [Integer] ID of the exempt role for this guild.
    # @param setup_by [Integer] ID of the user who setup vanity roles for this guild.
    # @param setup_at [Integer] Timestamp of when vanity roles were setup for this guild.
    def edit(**options)
      POSTGRES.transaction do
        options = options.except(:setup_by, :setup_at) unless blank?

        blank? ? @@pg.insert(**options) : @@pg.where(guild_id: guild).update(options)
      end
    end

    # Delete the record for this guild.
    # @note This method takes arguments, but currently they're ignored.
    def delete(**_options)
      POSTGRES.transaction { @@pg.where(guild_id: guild).delete }
    end

    private

    # @!visibility private
    def find_guild(*_options)
      @lazy ? {} : POSTGRES.transaction { @@pg.where(guild_id: @guild).first } || {}
    end
  end
end
