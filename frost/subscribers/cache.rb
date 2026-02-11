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

      GUILDS.order(:setup_at, :guild_id).paged_each do |row|
        @guilds[row[:guild_id]] = Guild.new(row)
      end

      BOOSTERS.order(:guild_id, :version).paged_each do |row|
        @boosters[row[:guild_id]][row[:user_id]] = Booster.new(row)
      end

      BANNED.order(:guild_id, :banned_at, :user_id).paged_each do |row|
        @banned[row[:guild_id]][row[:user_id]] = Banned.new(row)
      end
    end

    # Create the instance for this cache.
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

    # Delete a guild, permanently erasing its settings and boosters.
    # @param guild_id [Integer] The ID of the guild that should be deleted.
    # @return [Guild, nil] The guild that was deleted, or `nil` if there wasn't one to delete.
    def delete_guild(guild_id:)
      # Actually delete ts from the DB first because that's
      # our source of truth and we want to avoid an edge case where the local
      # cache contains a guild, but there's nothing for that guild in the actual database.
      @guilds[guild_id]&.delete

      # After that we can basically remove everything else once we're done touching the DB.
      @banned.delete(guild_id)
      @boosters.delete(guild_id)
      @guilds.delete(guild_id)
    end

    # Create a guild.
    # @param role_id [Integer] The ID of the hoist-role for the guild.
    # @param guild_id [Integer] The snowflake ID of the guild to create.
    # @param setup_by [Integer] The snowflake ID of the user creating the guild.
    # @param setup_at [Integer] The UNIX timestamp of when the guild was created.
    # @param added_features [Integer] The features to add to the guild when creating it.
    # @param unset_features [Integer] The features to remove from the guild when creating it.
    # @return [Integer, nil] The resulting state of the action, of the guild that was actioned on.
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
    # @param dead [true, false] Whether to return the deleted boosters.
    # @param users [Array<Integer>] The snowflake IDs of the users to ban.
    # @param guild_id [Integer] The snowflake ID of the guild the bans are for.
    # @param banned_by [Integer] The snowflake ID of the user creating the bans.
    # @param banned_at [Integer] The UNIX timestamp of when the bans was created.
    # @return [Array<Booster>, nil] The boosters that underwent removal, or `nil`.
    def create_bans(**options)
      POSTGRES.transaction do
        rest = { user_id: options[:users].map(&:to_i) }

        bans = rest[:user_id].map do |user_id|
          { user_id: user_id, **options.except(:users) }
        end

        bans = BANNED.insert_conflict.returning.multi_insert(bans)

        rest = BOOSTERS.where(**rest, guild_id: options[:guild_id])

        rest = options[:dead] ? rest.returning.delete : rest.delete

        bans.each do |ban|
          @boosters[ban[:guild_id]]&.delete(ban[:user_id])

          @banned[ban[:guild_id]][ban[:user_id]] = Banned.new(ban)
        end

        rest.map { |user| Booster.new(user) } if rest.is_a?(Array)
      end
    end

    # Delete multiple bans for a guild.
    # @param guild_id [Integer] The guild ID of the bans that should be deleted.
    # @param users [Array<Integer>] The user IDs of the bans that should be deleted.
    def delete_bans(guild_id:, users:)
      users = { user_id: users, guild_id: guild_id }

      users = BANNED.where(**users).returning(:user_id).delete

      users.each { |user| @banned[guild_id]&.delete(user[:user_id]) }
    end

    # Create a booster for a guild.
    # @param role [Role] The booster role for the user to create.
    # @param version [Integer] The interaction ID for the version.
    # @param user_id [Integer] The snowflake ID of the user to create.
    # @param guild_id [Integer] The snowflake ID of the guild the user to create is for.
    # @param role_color [Integer, nil] The color of the booster role for the user to create.
    def create_booster(**options)
      me = {
        version: options[:version],
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
    # @return [Booster, nil] The booster that was found during the lookup, or `nil` if it doesn't exist.
    def booster(guild_id:, user_id:, hit: false)
      @boosters[guild_id][user_id]&.then { return it }

      booster = BOOSTERS.where(guild_id: guild_id, user_id: user_id).first if hit
      @boosters[member[:guild_id]][member[:user_id]] = Booster.new(booster) if booster
    end

    # Delete a booster, permanently erasing its record.
    # @param user_id [Integer] The user ID of the booster that should be deleted.
    # @param guild_id [Integer] The guild ID of the booster that should be deleted.
    # @return [Booster, nil] The booster that was deleted, or `nil` if there wasn't one to delete.
    def delete_booster(user_id:, guild_id:)
      @boosters[guild_id][user_id]&.delete
      @boosters[guild_id]&.delete(user_id)
    end

    # Delete multiple boosters across multiple different guilds.
    # @param boosters [Array<Array<Integer, Integer, Integer>>] An array of arrays
    #   containing the guild ID (index [0]), user ID (index [1]), and version (index [2]) to delete.
    def delete_boosters(boosters)
      boosters = { %i[guild_id user_id version] => boosters }

      boosters = BOOSTERS.where(boosters).returning(:guild_id, :user_id).delete

      boosters.each { |booster| @boosters[booster[:guild_id]]&.delete(booster[:user_id]) }
    end

    # Get all of the boosters currently available.
    # @return [Array<Booster>] The boosters that are currently stored in the cache.
    def list_boosters
      boosters = @boosters.values.flat_map(&:values)

      block_given? ? boosters.each { yield(it) } : boosters
    end

    # Get a list of boosters stored in the cache, grouped by their guild.
    # @return [Array<Hash<Symbol => Integer, Symbol => Array<Integer>>>] The boosters grouped by guild.
    def chunks
      list_boosters.group_by(&:guild_id).map do |guild, users|
        { guild_id: guild, users: users.map(&:id) }
      end
    end
  end
end
