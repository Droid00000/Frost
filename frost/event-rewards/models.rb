# frozen_string_literal: true

module EventRoles
  # A guild role with linked users.
  class Role
    # Mapping of role feature flags.
    FEATURES = {
      disabled: 1 << 0
    }.freeze

    # @return [Integer] the ID of the role on Discord.
    attr_reader :id

    # @return [Integer] the feature flags combined as a bitfield.
    attr_reader :features

    # @return [Integer] the ID of the role's associated guild on Discord.
    attr_reader :guild_id

    # @return [Sequel::Dataset]
    USERS = BOT.db[:event_users]

    # @!visibility private
    def initialize(new_state)
      @users = Set[]
      @inner_flags = 0
      @users_lock = Mutex.new

      update_state(new_state)
    end

    #  ##     ##    ###    #### ##    ##
    #  ###   ###   ## ##    ##  ###   ##
    #  #### ####  ##   ##   ##  ####  ##
    #  ## ### ## ##     ##  ##  ## ## ##
    #  ##     ## #########  ##  ##  ####
    #  ##     ## ##     ##  ##  ##   ###
    #  ##     ## ##     ## #### ##    ##

    # @!group General

    # Delete the role. Will remove all users.
    # @return [void]
    def delete
      BOT.event_roles_cache.delete_role(@id)
    end

    # Modify the properties of the role.
    # @param add_features [Integer, nil] The feature flags to add to the role.
    # @param unset_features [Integer, nil] The feature flags to remove from the role.
    # @return [void]
    def modify(add_features: nil, unset_features: nil)
      rest = {
        features: Sequel.lit("(features | ?) & ~?",
                             add_features || 0, unset_features || 0)
      }.compact

      BOT.event_roles_cache.update_role(@id, rest) if @inner_flags.nobits?(1)
    end

    # @!endgroup

    #  ##     ##  ######  ######## ########   ######
    #  ##     ## ##    ## ##       ##     ## ##    ##
    #  ##     ## ##       ##       ##     ## ##
    #  ##     ##  ######  ######   ########   ######
    #  ##     ##       ## ##       ##   ##         ##
    #  ##     ## ##    ## ##       ##    ##  ##    ##
    #   #######   ######  ######## ##     ##  ######

    # @!group Users

    # Check if a user has been linked to the role.
    # @param user [User, Member, Integer] The user to check.
    # @return [true, false] Whether or not the user has been linked.
    def user?(user)
      @users.include?(user.resolve_id)
    end

    # Add multiple linked users to the role.
    # @param users [Array<User, Member, Integer>] The users to add.
    # @return [void]
    def add_users(users:)
      keys = %i[user_id role_id]

      list = users.map { [it.resolve_id, @id] }

      @users_lock.synchronize do
        rows = USERS.insert_conflict.returning(:user_id).import(keys, list)

        @bans.merge(rows.tap { rows.map! { |new_row| new_row[:user_id] } })
      end
    end

    # Remove multiple linked users from the role.
    # @param users [Array<User, Member, Integer>] The users to remove.
    # @return [void]
    def remove_users(users:)
      list = users.map(&:resolve_id)

      @users_lock.synchronize do
        rows = USERS.where(role_id: @id, user_id: list).returning(:user_id)

        rows.delete.each { |delete_row| @users.delete(delete_row[:user_id]) }
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
    def push_user(item)
      (@users << item.resolve_id)
    end

    # @!visibility private
    def update_state(new_state)
      @id = new_state[:role_id]
      @guild_id = new_state[:guild_id]
      @features = new_state[:features]
    end
  end
end
