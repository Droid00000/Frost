# frozen_string_literal: true

module Boosters
  # The cache-layer for boosters.
  class Storage
    # @return [Sequel::Dataset]
    BANNED = POSTGRES[:banned_boosters]

    # @return [Sequel::Dataset]
    GUILDS = POSTGRES[:booster_settings]

    # @return [Sequel::Dataset]
    BOOSTERS = POSTGRES[:guild_boosters]

    # @!visibility private
    def initialize
      @guilds = {}
      @banned = Hash.new { |hash, key| hash[key] = {} }
      @boosters = Hash.new { |hash, key| hash[key] = {} }

      GUILDS.order(:setup_at, :guild_id).paged_each(strategy: :filter) do |row|
        @guilds[row[:guild_id]] = Guild.new(row)
      end

      BOOSTERS.order(:guild_id, :user_id).paged_each(strategy: :filter) do |row|
        @boosters[row[:guild_id]][row[:user_id]] = Booster.new(row)
      end

      BANNED.order(:guild_id, :banned_at, :user_id).paged_each(strategy: :filter) do |row|
        @banned[row[:guild_id]][row[:user_id]] = Banned.new(row)
      end
    end

    # Create the instance for this real-time layer.
    # This does all of the setup needed to get everything going.
    def self.login
      @login ||= new
    end

    # @!visibility private
    def self.method_missing(name, ...)
      login.respond_to?(name) ? login.__send__(name, ...) : super
    end

    # Get a single guild.
    # @param guild_id [Integer] The guild ID of the guild that should be fetched.
    # @param hit [true, false] Whether to fallback to a database lookup if the guild isn't cached.
    # @return [Guild, nil] The guild that was found during the lookup, or `nil` if it doesn't exist.
    def guild(guild_id:, hit: false)
      guild = @guilds[guild_id.resolve_id]

      return guild if guild || hit != true

      guild = GUILDS.where(guild_id: guild_id).first
      @guilds[guild[:guild_id]] = Guild.new(guild) if guild
    end

    # Check if a guild exists.
    # @param guild_id [Integer] The guild ID of the guild that should be checked.
    # @param hit [true, false] Whether to fallback to a database lookup if the guild isn't cached.
    # @return [true, false] Whether or not the guild has been configured to utilize booster perks.
    def guild?(...)
      !guild(...).nil?
    end

    # Delete a guild, permanently erasing its settings and boosters.
    # @param guild_id [Integer] The ID of the guild that should be deleted.
    # @return [Guild, nil] The guild that was deleted, or `nil` if there wasn't one to delete.
    def delete_guild(guild_id:)
      @banned.delete(guild_id)
      @boosters.delete(guild_id)
      @guilds.delete(guild_id)&.tap(&:delete)
    end

    # Create a guild.
    # @param role_id [Integer] The ID of the hoist-role for the guild.
    # @param guild_id [Integer] The snowflake ID of the guild to create.
    # @param setup_by [Integer] The snowflake ID of the user creating the guild.
    # @param setup_at [Integer] The UNIX timestamp of when the guild was created.
    # @param added_features [Integer] The features to add to the guild when creating it.
    # @param unset_features [Integer] The features to remove from the guild when creating it.
    # @return [Integer] The resulting state of the action, of the guild that was actioned on.
    def create_guild(**options)
      if (cached_guild = guild(guild_id: options[:guild_id]))
        return 200.tap { cached_guild.edit(**options) }
      end

      options = {
        role_id: options[:role_id],
        guild_id: options[:guild_id],
        setup_by: options[:setup_by],
        setup_at: options[:setup_at],
        features: options[:added_features]
      }

      # We need a role to make the record here.
      return 400 unless options[:role_id]

      guild = GUILDS.insert_conflict.insert_select(**options)
      201.tap { @guilds[guild[:guild_id]] = Guild.new(guild) } if guild
    end

    # Check if a ban exists.
    # @param user_id [Integer] The user ID of the ban that should be fetched.
    # @param guild_id [Integer] The guild ID of the ban that should be fetched.
    # @param hit [true, false] Whether to fallback to a database lookup if the ban isn't cached.
    # @return [true, false] Whether or not the user for the given ID has been banned from the guild.
    def ban?(...)
      !ban(...).nil?
    end

    # Get a single ban.
    # @param user_id [Integer] The user ID of the ban that should be fetched.
    # @param guild_id [Integer] The guild ID of the ban that should be fetched.
    # @param hit [true, false] Whether to fallback to a database lookup if the ban isn't cached.
    # @return [Banned, nil] The banned user that was found during the lookup, or `nil` if it doesn't exist.
    def ban(user_id:, guild_id:, hit: false)
      ban = @banned[guild_id][user_id]

      return ban if ban || hit != true

      ban = BANNED.where(guild_id: guild_id, user_id: user_id).first
      @banned[ban[:guild_id]][ban[:user_id]] = Banned.new(ban) if ban
    end

    # Create multiple bans for a guild.
    # @param users [Array<Integer>] The snowflake IDs of the users to ban.
    # @param guild_id [Integer] The snowflake ID of the guild the bans are for.
    # @param banned_by [Integer] The snowflake ID of the user creating the bans.
    # @param banned_at [Integer] The UNIX timestamp of when the bans was created.
    def create_bans(**options)
      bans = options[:users].map do |user_id|
        { user_id: user_id, **options.except(:users) }
      end

      bans = BANNED.insert_conflict.returning.multi_insert(bans)

      bans.each do |ban|
        @banned[ban[:guild_id]][ban[:user_id]] = Banned.new(ban)

        @boosters[ban[:guild_id]]&.delete(ban[:user_id])&.delete
      end
    end

    # Delete multiple bans for a guild.
    # @param guild_id [Integer] The guild ID of the bans that should be deleted.
    # @param users [Array<Integer>] The user IDs of the bans that should be deleted.
    def delete_bans(guild_id:, users:)
      BANNED.where(guild_id: guild_id, user_id: users).delete

      @banned[guild_id]&.delete_if { |user, _| users.any?(user) }
    end

    # Create a booster for a guild.
    # @param role [Role] The booster role for the user to create.
    # @param user_id [Integer] The snowflake ID of the user to create.
    # @param guild_id [Integer] The snowflake ID of the guild the user to create is for.
    # @param role_color [Integer, nil] The color of the booster role for the user to create.
    def create_booster(**options)
      me = {
        user_id: options[:user_id],
        guild_id: options[:guild_id]
      }

      options = {
        **me,
        role_id: options[:role].resolve_id,
        color_id: options[:role].color.to_i
      }

      booster = BOOSTERS.insert_select(**options)
      201.tap { @boosters[booster[:guild_id]][booster[:user_id]] = Booster.new(booster) } if booster
    end

    # Get a single booster.
    # @param user_id [Integer] The user ID of the booster that should be fetched.
    # @param guild_id [Integer] The guild ID of the booster that should be fetched.
    # @param hit [true, false] Whether to fallback to a database lookup if the booster isn't cached.
    # @return [Booster, Banned, nil] The booster that was found during the lookup, it's ban entry, or `nil` if it doesn't exist.
    def booster(guild_id:, user_id:, hit: false)
      @banned[guild_id.to_i][user_id.to_i]&.then { return it }

      @boosters[guild_id.to_i][user_id.to_i]&.then { return it }

      booster = BOOSTERS.where(guild_id: guild_id, user_id: user_id).first if hit
      @boosters[member[:guild_id]][member[:user_id]] = Booster.new(booster) if booster
    end

    # Check if a booster exists.
    # @param user_id [Integer] The user ID of the booster that should be fetched.
    # @param guild_id [Integer] The guild ID of the booster that should be fetched.
    # @param hit [true, false] Whether to fallback to a database lookup if the booster isn't cached.
    # @return [true, false] Whether or not the user for the given ID is a booster within the guild.
    def booster?(...)
      !booster(...).nil?
    end

    # Delete a booster, permanently erasing its record.
    # @param user_id [Integer] The user ID of the booster that should be deleted.
    # @param guild_id [Integer] The guild ID of the booster that should be deleted.
    # @return [Booster, nil] The booster that was deleted, or `nil` if there wasn't one to delete.
    def delete_booster(user_id:, guild_id:)
      @boosters[guild_id.to_i]&.delete(user_id.to_i)&.tap(&:delete)
    end

    # Get all of the boosters currently available.
    # @return [Array<Booster>] The boosters stored on the real-time layer.
    def list_boosters
      boosters = @boosters.values.flat_map(&:values)

      block_given? ? boosters.each { yield(it) } : boosters
    end

    alias boosters list_boosters

    # Get a list of users stored on the real-time layer, grouped by their guild.
    # @return [Array<Hash<Symbol => Integer, Symbol => Array<Integer>>>] The boosters grouped by guild.
    def chunks
      boosters.group_by { it.guild.id }.map do |guild, users|
        { guild_id: guild, users: users.map(&:id) }
      end
    end
  end
end
