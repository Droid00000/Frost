# frozen_string_literal: true

module Boosters
  # Booster settings for a guild.
  class Guild
    # Mapping of guild feature flags.
    FEATURES = {
      any_icon: 1 << 0,
      no_gradient: 1 << 1
    }.freeze

    # @return [Integer] the ID of the guild on Discord.
    attr_reader :id

    # @return [Integer] the ID of the hoist role in the guild.
    attr_reader :role_id

    # @return [Integer] the feature flags combined as a bitfield.
    attr_reader :features

    # @return [Integer] the ID of the user who enabled booster perks.
    attr_reader :setup_by

    # @return [Integer] the unix time at when booster perks were enanbled.
    attr_reader :setup_at

    # @return [Sequel::Dataset]
    BANS = BOT.db[:banned_boosters]

    # @return [Sequel::Dataset]
    BOOSTERS = BOT.db[:guild_boosters]

    # @!visibility private
    def initialize(new_state)
      @bans = Set[]
      @boosters = {}
      @lock = Mutex.new
      @bans_lock = Mutex.new

      update_state(new_state)
    end

    #  ########     ###    ##    ##  ######
    #  ##     ##   ## ##   ###   ## ##    ##
    #  ##     ##  ##   ##  ####  ## ##
    #  ########  ##     ## ## ## ##  ######
    #  ##     ## ######### ##  ####       ##
    #  ##     ## ##     ## ##   ### ##    ##
    #  ########  ##     ## ##    ##  ######

    # @!group Bans

    # Check if a user has been banned.
    # @param user [User, Member, Integer] The user to check.
    # @return [true, false] Whether or not the user has been banned.
    def banned?(user)
      @bans.include?(user.resolve_id)
    end

    # Delete multiple bans for the guild.
    # @param users [Array<User, Member, Integer>] The users to un-ban.
    # @return [void]
    def delete_bans(users:)
      list = users.map(&:resolve_id)

      @bans_lock.synchronize do
        rows = BANS.where(guild_id: @id, user_id: list).returning(:user_id)

        rows.delete.each { |delete_row| @bans.delete(delete_row[:user_id]) }
      end
    end

    # Create multiple bans for the guild.
    # @param users [Array<User, Member, Integer>] The users to ban.
    # @param banned_by [User, Member, Integer] The user creating the bans.
    # @return [void]
    def create_bans(users:, banned_by:)
      unix = Time.now.to_i
      user = banned_by.resolve_id
      keys = %i[user_id guild_id banned_at banned_by]

      list = users.map { [it.resolve_id, @id, unix, user] }

      @bans_lock.synchronize do
        @bans.merge(BANS.insert_ignore.returning(:user_id).import(keys, list))
      end
    end

    #  ########   ######   ######   ######  ######## ######## ########   ######
    #  ##     ## ##    ## ##    ## ##    ##    ##    ##       ##     ## ##    ##
    #  ##     ## ##    ## ##    ## ##          ##    ##       ##     ## ##
    #  ########  ##    ## ##    ##  ######     ##    ######   ########   ######
    #  ##     ## ##    ## ##    ##       ##    ##    ##       ##   ##         ##
    #  ##     ## ##    ## ##    ## ##    ##    ##    ##       ##    ##  ##    ##
    #  ########   ######   ######   ######     ##    ######## ##     ##  ######

    # @!group Boosters

    # Fetch a single booster.
    # @param user_id [Member, Integer] The ID of the booster to fetch.
    # @return [Boosters::Booster, nil] The booster for the given user ID.
    def fetch_booster(user_id)
      @boosters[user_id.resolve_id]
    end

    # Delete a single booster for the guild.
    # @param id [Member, Integer] The user ID of the booster.
    # @param version [Integer, nil] An optional version to match against.
    def delete_booster(id:, version: nil)
      rest = {
        guild_id: @id,
        user_id: id.resolve_id,
        version: version&.resolve_id
      }.compact

      @lock.synchronize do
        if (row = BOOSTERS.where(**rest).returning.delete.first)
          now = @boosters[rest[:user_id]]&.version

          @boosters.delete(rest[:user_id]) if now == row[:version]
        end
      end
    end

    # Create a single booster for the guild.
    # @param id [Member, Integer] The user ID of the booster.
    # @param role [Role, Integer] The ID of the booster's linked role.
    # @param version [Integer] The snowflake interaction ID of the booster.
    def create_booster(id:, role:, version:)
      rest = {
        user_id: id.resolve_id,
        role_id: role.resolve_id,
        version: version.resolve_id
      }

      @lock.synchronize do
        push_booster(BOOSTERS.insert_select(guild_id: @id, **rest))
      end
    end

    # Delete multiple boosters for the guild.
    # @param boosters [Array<Booster>] The boosters to delete.
    def delete_boosters(boosters)
      columns = %i[user_id version]

      return if !boosters || boosters.empty?

      rest = {
        guild_id: @id,
        columns => boosters.map { [it.id, it.version] }
      }

      @lock.synchronize do
        rows = BOOSTERS.where(**rest).returning.delete

        rows.each do |row|
          next unless (now = @boosters[row[:user_id]]&.version)

          @boosters.delete(row[:user_id]) if now == row[:version]
        end
      end
    end

    # Reconcile each booster in the guild with Discord.
    def audit_boosters
      items = @boosters.clone

      user_ids = items.keys.each_slice(100)

      return unless (guild = BOT.discord.guild(@id))

      return unless guild.current_bot.can_manage_roles?

      chunks = user_ids.map { guild.query_members(users: it) }

      tombstones = []

      # Loop over each GUILD_MEMBERS_CHUNK that we recieved.
      chunks.each do |result|
        # The set of members that are still a part of the guild.
        result.each do |member|
          next if member.premium_since

          booster = items[member.user.id]

          role = guild.role(booster.role_id)

          next if role && role >= guild.current_bot.highest_role

          role&.delete(reason: "Booster Roles (ID: #{booster.id})")

          tombstones << booster
        end

        # The set of user IDs that have left the guild or are invalid.
        result.not_found.each do |id|
          booster = items[id.resolve_id]

          role = guild.role(booster.role_id)

          next if role && role >= guild.current_bot.highest_role

          role&.delete(reason: "Booster Roles (ID: #{booster.id})")

          tombstones << booster
        end
      end

      delete_boosters(tombstones)
    end

    # @!endgroup

    #  ######## ########    ###    ######## ##     ## ########   ########   ######
    #  ##       ##         ## ##      ##    ##     ## ##     ##  ##        ##    ##
    #  ##       ##        ##   ##     ##    ##     ## ##     ##  ##        ##
    #  ######   ######   ##     ##    ##    ##     ## ########   ######     ######
    #  ##       ##       #########    ##    ##     ## ##   ##    ##              ##
    #  ##       ##       ##     ##    ##    ##     ## ##    ##   ##        ##    ##
    #  ##       ######## ##     ##    ##     #######  ##     ##  ########   ######

    # @!group Features

    # @!method any_icon?
    #   @return [true, false] whether boosters can use any emoji for their role icon.
    # @!method no_gradient?
    #   @return [true, false] whether boosters cannot use gradient colors for their roles.
    FEATURES.each do |name, value|
      define_method("#{name}?") { @features.anybits?(value) }
    end

    # @!endgroup

    #  ####  ###   ## ######## ######## ########  ##    ##    ###    ##        ######
    #   ##   ###   ##    ##    ##       ##     ## ###   ##   ## ##   ##       ##    ##
    #   ##   ####  ##    ##    ##       ##     ## ####  ##  ##   ##  ##       ##
    #   ##   ## ## ##    ##    ######   ########  ## ## ## ##     ## ##        ######
    #   ##   ##  ####    ##    ##       ##   ##   ##  #### ######### ##             ##
    #   ##   ##   ###    ##    ##       ##    ##  ##   ### ##     ## ##       ##    ##
    #  ####  ##    ##    ##    ######## ##     ## ##    ## ##     ## ########  ######

    # @!visibility private
    def push_ban(value)
      @bans << value.resolve_id
    end

    # @!visibility private
    def push_booster(value)
      @boosters[value[:user_id]] = Booster.new(value)
    end

    # @!visibility private
    def update_state(new_state)
      @id = new_state[:guild_id]
      @role_id = new_state[:role_id]
      @features = new_state[:features]
      @setup_by = new_state[:setup_by]
      @setup_at = new_state[:setup_at]
    end
  end

  # A booster for a guild.
  class Booster
    # @return [Integer] the ID of the user on Discord.
    attr_reader :id

    # @return [Integer] the ID of the user's role in the guild.
    attr_reader :role_id

    # @return [Integer] a snowflake representing the booster's version.
    attr_reader :version

    # @!visibility private
    def initialize(new_state)
      @id = new_state[:user_id]
      @role_id = new_state[:role_id]
      @version = new_state[:version]
    end

    # Retrieve the time at when the booster was created.
    # @return [Time] The time at when the booster was created.
    def creation_time
      @creation_time ||= Discordrb::Snowflake.decompose(@version)
    end
  end
end
