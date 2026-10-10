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

    # @!visibility private
    def initialize(new_state)
      @bans = Set[]
      @inner_flags = 0
      @bans_lock = Mutex.new

      update_state(new_state)
      @boosters = Concurrent::Map.new
    end

    #  ##     ##    ###    #### ##    ##
    #  ###   ###   ## ##    ##  ###   ##
    #  #### ####  ##   ##   ##  ####  ##
    #  ## ### ## ##     ##  ##  ## ## ##
    #  ##     ## #########  ##  ##  ####
    #  ##     ## ##     ##  ##  ##   ###
    #  ##     ## ##     ## #### ##    ##

    # @!group General

    # Delete the guild. Will remove all boosters and bans.
    # @return [void]
    def delete
      BOT.boosters_cache.delete_guild(@id)
    end

    # Modify the properties of the guild.
    # @param role [Role, Integer, nil] The new hoist role of the guild.
    # @param add_features [Integer, nil] The feature flags to add to the guild.
    # @param unset_features [Integer, nil] The feature flags to remove from the guild.
    # @return [void]
    def modify(role: nil, add_features: nil, unset_features: nil)
      rest = {
        role_id: role&.resolve_id,
        features: Sequel.lit("(features | ?) & ~?",
                             add_features || 0, unset_features || 0)
      }.compact

      BOT.boosters_cache.update_guild(@id, rest) if @inner_flags.nobits?(1)
    end

    # @!endgroup

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
        rows = BANS.insert_conflict.returning(:user_id).import(keys, list)

        @bans.merge(rows.tap { rows.map! { |new_row| new_row[:user_id] } })
      end
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
    def set_tombstone_state
      @inner_flags |= (1 << 0)
    end

    # @!visibility private
    def push_ban(item)
      (@bans << item.resolve_id)
    end

    # @!visibility private
    def push_booster(item)
      @boosters[item[:user_id]] = Booster.new(item)
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
end
