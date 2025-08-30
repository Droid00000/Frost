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
    attr_reader :role_id
    alias hoist_role role_id

    # @return [Integer, nil]
    attr_reader :enabled_by
    alias setup_by enabled_by

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

    # @return [Sequel::Dataset]
    @@bans = POSTGRES[:banned_boosters]

    # @!visibility private
    def initialize(data, **rest)
      @bot = data.bot
      @lazy = rest[:lazy]
      @guild = data.server.id
      model = find_guild(**rest)
      @role_id = model[:role_id]
      @any_icon = model[:any_icon]
      @enabled_by = model[:setup_by]
      @enabled_at = model[:setup_at]
    end

    # Check if this guild is nil, e.g. hasn't been setup.
    # @return [Boolean] Whether this guild is nil or not.
    def blank? = role_id.nil?

    # Get metadata about the settings for this guild.
    # @return [Array(String, Integer)] Metadata info about this guild.
    def view = [@bot.user(enabled_by)&.name, enabled_at]

    # Delete the record for this guild.
    # @note This method takes arguments, but currently they're ignored.
    def delete(**_options)
      POSTGRES.transaction { @@pg.where(guild_id: guild).delete }
    end

    # Get a list of all the members banned in this guild.
    # @param offset [Integer, nil] The number of bans to skip before returning results.
    # @return [Array<Sequel::Dataset>] An array of all the banned members for the guild.
    def bans(**options)
      POSTGRES.transaction do
        @@bans.where(guild_id: guild).offset(options[:offset] || 0).order(:user_id)
      end
    end

    # Create a new record or update an existing record.
    # @param guild_id [Integer] ID of the guild this record is for.
    # @param role_id [Integer] ID of the hoist-role for this guild.
    # @param any_icon [Boolean] Whether this guild supports external role icons.
    # @param setup_by [Integer] ID of the user who setup booster perks for this guild.
    # @param setup_at [Integer] Timestamp of when booster perks were setup for this guild.
    def edit(**options)
      POSTGRES.transaction do
        options = options.slice(:role_id, :any_icon) unless blank?

        blank? ? @@pg.insert(**options) : @@pg.where(guild_id: guild).update(options)
      end
    end

    private

    # @!visibility private
    def find_guild(**options)
      @lazy ? options : POSTGRES.transaction { @@pg.where(guild_id: @guild).first } || options
    end
  end

  # Represents a singular booster.
  class Member
    # @return [Hash]
    attr_reader :query

    # @return [Guild]
    attr_reader :guild

    # @return [Integer, nil]
    attr_reader :color

    # @return [Integer, nil]
    attr_reader :role

    # @return [Sequel::Dataset]
    @@bans = POSTGRES[:banned_boosters]

    # @return [Sequel::Dataset]
    @@users = POSTGRES[:guild_boosters]

    # @!visibility private
    def initialize(data, **rest)
      @data = data
      @lazy = rest[:lazy]
      @guild_id = data.server.id
      @target_id = data.options["target"] || data.user.id
      @query = { user_id: @target_id, guild_id: @guild_id }
      model = find_guild_booster(*@query.values.map(&:to_i))
      @guild = Guild.new(@data, lazy: true, **model.slice(:role_id, :any_icon))
      @banned, @role, @color = model[:banned], model[:user_role], model[:color_id]
    end

    # Check if this user is nil, e.g. has no role.
    # @return [Boolean] Whether this user is nil or not.
    def blank? = role.nil?

    # Check if this user has been banned from using booster perks.
    # @return [Boolean] Whether this user cannot use booster perks.
    def banned? = @banned || false

    # Ban this user from using booster perks in this guild.
    def ban(**)
      POSTGRES.transaction do
        @@users.where(**query).delete

        @@bans.insert_conflict.insert(**query, **)
      end
    end

    # Unban a user from using booster perks in this guild.
    def unban
      POSTGRES.transaction { @@bans.where(**query).delete }
    end

    # Remove this members booster records in this guild.
    def delete
      POSTGRES.transaction { @@users.where(**query).delete }
    end

    # Set the base role color used by this member.
    # @param color [ColourRGB, Integer] The new base color.
    def color=(color)
      POSTGRES.transaction { @@users.where(**query).update(color_id: color.to_i) }
    end

    # Edit this members booster role in this guild.
    # @note This will update the members role if it already exists.
    def role=(role)
      POSTGRES.transaction do
        @@users.insert_conflict(**conflict(role)).insert(**query, **conflict(role)[:update])
      end
    end

    private

    # @!visibility private
    def conflict(*options)
      {
        target: %i[user_id guild_id],
        update: {
          role_id: options.first.resolve_id,
          color_id: options.first.color.to_i
        }
      }
    end

    # @!visibility private
    def find_guild_booster(*options)
      @lazy ? {} : POSTGRES["SELECT * FROM guild_booster(?, ?)", *options].first || {}
    end
  end

  # Class for singleton methods that are required for role audits.
  class Members
    # Get a list of all the boosters that are in the database.
    # @return [Array<Hash<Symbol => Integer>>, Sequel::Dataset]
    def self.stream
      POSTGRES[:guild_boosters].all.map do |member|
        { **member, reason: "Booster Roles (ID: #{member[:user_id]})" }
      end
    end

    # Get a list of all the boosters that are in the database.
    # @return [Array<Hash<Symbol => Integer, Symbol => Array>>]
    def self.chunks
      stream.group_by { |member| member[:guild_id] }.map do |guild, members|
        { guild_id: guild, members: members.map { |user| user[:user_id] } }
      end
    end

    # Delete a singular booster from the database from the given options.
    # @param guild_id [Integer, String] ID of the guild the record is for.
    # @param user_id [Integer, String] ID of the user the record is for.
    def self.delete(**)
      POSTGRES.transaction { POSTGRES[:guild_boosters].where(**).delete }
    end
  end
end
