# frozen_string_literal: true

module EventRoles
  # A guild role with linked users.
  class Role
    # @return [Integer] the ID of the role on Discord.
    attr_reader :id

    # @return [Integer] the ID of the role's associated guild on Discord.
    attr_reader :guild_id

    # @return [Sequel::Dataset]
    USERS = BOT.db[:event_users]

    # @!visibility private
    def initialize(new_state)
      @users = Set[]
      @users_lock = Mutex.new

      update_state(new_state)
    end

    #  ##     ##  ######  ######## ########   ######
    #  ##     ## ##    ## ##       ##     ## ##    ##
    #  ##     ## ##       ##       ##     ## ##
    #  ##     ##  ######  ######   ########   ######
    #  ##     ##       ## ##       ##   ##         ##
    #  ##     ## ##    ## ##       ##    ##  ##    ##
    #   #######   ######  ######## ##     ##  ######

    # @!group Users

    # Get the number of users linked to the role.
    # @return [Integer] The number of users linked to the role.
    def user_count
      @users.length
    end

    # Check if a user has been linked to the role.
    # @param user [User, Member, Integer] The user to check.
    # @return [true, false] Whether or not the user has been linked.
    def user?(user)
      @users.include?(user.resolve_id)
    end

    # Modify the users of the event role.
    # @param add [Array<Integer, User, Member>, nil] The users to add to the event role.
    # @param remove [Array<Integer, User, Member>, nil] The users to remove from the event role.
    def modify_users(add: nil, remove: nil)
      remove = remove&.map(&:resolve_id) || []

      insert = add&.map { [it.resolve_id, @id] } || []

      @users_lock.synchronize do
        BOT.db.transaction(isolation: :serializable) do
          if insert.any?
            add = USERS
                  .insert_conflict
                  .returning(:user_id)
                  .import(%i[user_id role_id], insert)
          end

          if remove.any?
            remove = USERS
                     .returning(:user_id)
                     .where(role_id: @id, user_id: remove)
                     .delete
          end
        end

        add&.each { |item| @users << item }

        remove&.each { |item| @users.delete(item[:user_id]) }
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
    def push_user(item)
      @users << item.resolve_id
    end

    # @!visibility private
    def update_state(new_state)
      @id = new_state[:role_id]
      @guild_id = new_state[:guild_id]
    end
  end
end
