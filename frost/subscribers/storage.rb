# frozen_string_literal: true

module Boosters
  # A guild that a server booster belongs to.
  class Guild
    # Map of guild flags.
    FLAGS = {
      any_icon: 1 << 0,
      no_gradient: 1 << 1,
      self_service: 1 << 2,
      manual_queue: 1 << 3
    }.freeze

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
    attr_reader :features
    alias flags features

    # @return [Integer, nil]
    attr_reader :enabled_by
    alias setup_by enabled_by

    # @return [Integer, nil]
    attr_reader :enabled_at
    alias setup_at enabled_at

    # @return [Sequel::Dataset]
    @@pg = POSTGRES[:booster_settings]

    # @return [Sequel::Dataset]
    @@bans = POSTGRES[:banned_boosters]

    # @!visibility private
    def initialize(data, **rest)
      @bot = data.bot
      @lazy = rest[:lazy]
      @guild = data.server.id
      model = find_guild(**rest)
      @role_id = model[:role_id]
      @features = model[:features]
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
    def delete(**_options) = @@pg.where(guild_id: guild).delete

    # Get a list of all the members banned in this guild.
    # @param offset [Integer, nil] The number of bans to skip before returning results.
    # @return [Array<Sequel::Dataset>] An array of all the banned members for the guild.
    def bans(**options)
      @@bans.where(guild_id: guild).offset(options[:offset] || 0).order(:user_id)
    end

    # Create a new record or update an existing record.
    # @param role_id [Integer] The ID of the hoist-role for this guild.
    # @param user_id [Integer] The ID of the who's user editing this guild.
    # @param added_features [Integer] The feature flags to set for this guild.
    # @param unset_features [Integer] The feature flags to remove for this guild.
    # @return [Integer] The resulting state of the query. `400` for error, `200` for success.
    def edit(**options)
      query = <<~SQL
        SELECT * FROM set_booster_settings(?, ?, ?, ?, ?);
      SQL

      POSTGRES[query, guild, options[:role_id], options[:user_id],
               options[:added_features], options[:unset_features]].first[:set_booster_settings]
    end

    # @!method any_icon?
    #   @return [Boolean] whether guild boosters can use external emojis as role icons.
    # @!method no_graident?
    #   @return [Boolean] whether setting graidents to booster roles has been disabled.
    # @!method self_service?
    #   @return [Boolean] whether this guild is using the self service mode for booster perks.
    # @!method manual_queue?
    #   @return [Boolean] whether this guild is using the manual approval mode for booster perks.
    FLAGS.each do |name, value|
      define_method("#{name}?") do
        @features.anybits?(value)
      end
    end

    private

    # @!visibility private
    def find_guild(**options)
      @lazy ? options : @@pg.where(guild_id: @guild).first || options
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
      @guild = Guild.new(@data, lazy: true, **model.slice(:role_id, :features))
      @banned, @role, @color = model[:banned], model[:user_role], model[:color_id]
    end

    # Check if this user is nil, e.g. has no role.
    # @return [Boolean] Whether this user is nil or not.
    def blank? = role.nil?

    # Check if this user has been banned from using booster perks.
    # @return [Boolean] Whether this user cannot use booster perks.
    def banned? = @banned || false

    # Unban a user from using booster perks in this guild.
    def unban
      @@bans.where(**query).delete
    end

    # Remove the record for this booster in this this guild.
    def delete
      @@users.where(**query).delete
    end

    # Check if this user's role has been deleted in this guild.
    # @return [Boolean] Whether the user's role has been deleted.
    def blank_role?
      role ? @data.server.role(role).nil? : false
    end

    # Ban this user from using booster perks in this guild.
    # @param banned_by [Integer] the user who's issuing the ban.
    # @param banned_at [Integer] the time at when the ban happened.
    def ban(**)
      POSTGRES.transaction do
        @@users.where(**query).delete

        @@bans.insert_conflict.insert(**query, **)
      end
    end

    # Set the base role color used by this member.
    # @param color [ColourRGB, Integer] The new base color.
    def color=(color)
      @@users.where(**query).update(color_id: color.to_i)
    end

    # Edit this members booster role in this guild.
    # @note This will update the members role if it already exists.
    def role=(role)
      @@users.insert_conflict(**conflict(role)).insert(**query, **conflict(role)[:update])
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
