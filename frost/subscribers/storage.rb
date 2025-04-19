# frozen_string_literal: true

module Boosters
  # A guild that a server booster belongs to.
  class Guild
    # @return [Integer]
    attr_reader :guild
    alias guild_id guild

    # @return [Integer, nil]
    attr_reader :enabled_by
    alias setup_by enabled_by

    # @return [Integer, nil]
    attr_reader :hoist_role
    alias role hoist_role

    # @return [Integer, nil]
    attr_reader :enabled_at
    alias setup_at enabled_at

    # @return [Boolean, nil]
    attr_reader :any_icon
    alias any_icon? any_icon

    # @return [Dataset]
    @@pg = POSTGRES[:booster_settings]

    # @!visibility private
    def initialize(data)
      @bot = data.bot
      @guild = data.server.id
      @model = find_guild(@guild)
      @any_icon = @model[:any_icon]
      @hoist_role = @model[:hoist_role]
      @enabled_by = @model[:enabled_by]
      @enabled_at = @model[:enabled_at]
    end

    # Check if this guild is nil, e.g. hasn't been setup.
    # @return [Boolean] Whether this guild is nil or not.
    def blank? = hoist_role.nil?

    # Get metadata about the settings for this guild.
    # @return [Array<String, Integer>] Metadata info about this guild.
    def view = [enabler&.name, enabled_at]

    # Get the user who enabled this functionality in this guild.
    # @return [Discordrb::User] The user who enabled this functionality.
    def enabler = @enabler ||= @bot.user(enabled_by)

    # Create a new record or update an existing record.
    # @param guild_id [Integer] ID of the guild this record is for.
    # @param hoist_role [Integer] ID of the hoist-role for this guild.
    # @param any_icon [Boolean] Whether this guild supports external role icons.
    # @param setup_by [Integer] ID of the user who setup booster perks for this guild.
    # @param setup_at [Integer] Timestamp of when booster perks were setup for this guild.
    def edit(**options)
      POSTGRES.transaction do
        options = transform_options(options)

        @@pg.insert_conflict(**conflict(options)).insert(**options)
      end
    end

    # Delete the record for this guild.
    # @note This method takes arguments, but currently they're ignored.
    def delete(**_options)
      POSTGRES.transaction do
        @@pg.where(guild_id: guild).delete

        @@users.where(guild_id: guild).delete
      end
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
      POSTGRES.transaction { @@pg.where(guild: options[0]).first }
    end

    # @!visibility private
    def conflict(*options)
      { target: :guild_id, update: options[0].except(:enabled_by, :enabled_at) }
    end
  end

  # Represents a singular booster.
  class User
    # @return [Hash]
    attr_reader :query

    # @return [Integer]
    attr_reader :user_id
    alias user user_id

    # @return [Integer]
    attr_reader :guild_id

    # @return [Sequel::Dataset]
    @@bans = POSTGRES[:banned_boosters]

    # @return [Sequel::Dataset]
    @@users = POSTGRES[:guild_boosters]

    # @!visibility private
    def initalize(data)
      @data = data
      @bot = data.bot
      @user_id = data.user.id
      @guild_id = data.server.id
      @query = { guild_id: guild, user_id: user }

      if data.options["member"]
        @query[:user_id] = data.options["member"].to_i
      end
    end

    # Check if this user is nil, e.g. has no role.
    # @return [Boolean] Whether this user is nil or not.
    def blank? = role.nil?

    # Get the booster guild this member is a part of.
    # @return [Guild] The guild this booster is part of.
    def guild = @guild ||= Guild.new(@data)

    # Unban a user from using booster perks in this guild.
    def unban
      POSTGRES.transaction { @@bans.where(**query).delete }
    end

    # Check if this user is banned from using booster perks.
    # @return [Boolean] Whether this user is banned or not.
    def banned?
      POSTGRES.transaction { !@@bans.where(**query).empty? }
    end

    # Remove this members booster records in this guild.
    def delete
      POSTGRES.transaction { @@users.where(**query).delete }
    end

    # Ban this user from using booster perks in this guild.
    def ban
      POSTGRES.transaction { @@bans.insert(**query) } && delete
    end

    # Get this members booster role in this guild.
    # @return [Integer] The role ID of the booster role.
    def role
      @role ||= POSTGRES.transaction { @@users.where(**query).get(:role_id) }
    end

    # Edit this members booster role in this guild.
    # @note This will update the members role if it already exists.
    def role=(role)
      POSTGRES.transaction do
        @@users.insert_conflict(**conflict(role)).insert(**query, role_id: role.id)
      end
    end

    private

    # @!visibility private
    def conflict(*options)
      { target: :user_id, update: { role_id: options[0].id } }
    end
  end
end
