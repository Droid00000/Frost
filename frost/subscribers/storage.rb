# frozen_string_literal: true

module Boosters
  # A guild that a server booster belongs to.
  class Guild
    # @return [Boolean]
    attr_reader :lazy
    alias lazy? lazy

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

    # @return [Sequel::Dataset]
    @@pg = POSTGRES[:booster_settings]

    # @return [Sequel::Dataset]
    @@users = POSTGRES[:guild_boosters]

    # @!visibility private
    def initialize(data, lazy: false)
      @bot = data.bot
      @lazy = lazy == true
      @guild = data.server.id
      @model = find_guild(@guild)
      @any_icon = @model[:any_icon]
      @enabled_by = @model[:setup_by]
      @enabled_at = @model[:setup_at]
      @hoist_role = @model[:hoist_role]
    end

    # Check if this guild is nil, e.g. hasn't been setup.
    # @return [Boolean] Whether this guild is nil or not.
    def blank? = hoist_role.nil?

    # Get metadata about the settings for this guild.
    # @return [Array<String, Integer>] Metadata info about this guild.
    def view = [@bot.user(enabled_by)&.name, enabled_at]

    # Create a new record or update an existing record.
    # @param guild_id [Integer] ID of the guild this record is for.
    # @param hoist_role [Integer] ID of the hoist-role for this guild.
    # @param any_icon [Boolean] Whether this guild supports external role icons.
    # @param setup_by [Integer] ID of the user who setup booster perks for this guild.
    # @param setup_at [Integer] Timestamp of when booster perks were setup for this guild.
    def edit(**options)
      POSTGRES.transaction do
        options = options.slice(:hoist_role, :any_icon) unless blank?

        blank? ? @@pg.insert(**options) : @@pg.where(guild_id: guild).update(options)
      end
    end

    # Delete the record for this guild.
    # @note This method takes arguments, but currently they're ignored.
    def delete(**_options)
      POSTGRES.transaction do
        # Remove the settings record.
        @@pg.where(guild_id: guild).delete

        # Remove all active boosters.
        @@users.where(guild_id: guild).delete
      end
    end

    private

    # @!visibility private
    def find_guild(*_options)
      @lazy ? {} : POSTGRES.transaction { @@pg.where(guild_id: @guild).first } || {}
    end
  end

  # Represents a singular booster.
  class Member
    # @return [Hash]
    attr_reader :query

    # @return [Integer]
    attr_reader :user_id

    # @return [Integer]
    attr_reader :guild_id

    # @return [Sequel::Dataset]
    @@bans = POSTGRES[:banned_boosters]

    # @return [Sequel::Dataset]
    @@users = POSTGRES[:guild_boosters]

    # @!visibility private
    def initialize(data)
      @data = data
      @user_id = data.user.id
      @guild_id = data.server.id
      @query = { guild_id: @guild_id, user_id: @user_id }

      return unless data.options["target"]

      @query[:user_id] = data.options["target"].to_i
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
    def ban(**)
      POSTGRES.transaction do
        @@users.where(**query).delete

        @@bans.insert_conflict.insert(**query, **)
      end
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
        @@users.insert_conflict(**conflict(role)).insert(**query, role_id: role)
      end
    end

    private

    # @!visibility private
    def conflict(*options)
      { target: %i[user_id guild_id], update: { role_id: options[0].resolve_id } }
    end
  end

  # Class for singleton methods that are required for for role audits.
  class Members
    # Get a list of all the boosters that are in the database.
    # @return [Array<Hash<Symbol => Integer>>, Sequel::Dataset]
    def self.stream = POSTGRES[:booster_settings].all

    # Get all the boosters that are in the database with a reason.
    # @return [Array<Hash<Symbol => Integer Symbol => String>>]
    def self.list = stream.to_a.each { it[:reason] = reason(it) }

    # Get a list of all the boosters that are in the database.
    # @return [Array<Hash<Symbol => Integer, Symbol => Array>>]
    def self.chunks
      stream.group_by { |member| member[:guild_id] }.map do |guild, users|
        { guild_id: guild, members: users.map { |user| user[:user_id] } }
      end
    end

    # Produce an audit log to show when operating on the current role.
    # @param data [Interaction] The current interaction the entry is for.
    # @return [String] A string that denotes the action type and current user ID.
    def self.reason(*options) = format(::Boosters::REASON, options[0][:user_id])

    # Delete a singular booster from the database from the given options.
    # @param guild_id [Integer, String] ID of the guild the record is for.
    # @param user_id [Integer, String] ID of the user the record is for.
    def self.delete(*options)
      POSTGRES.transaction { @@users.where(guild_id: options[0], user_id: options[1]) }
    end
  end
end
