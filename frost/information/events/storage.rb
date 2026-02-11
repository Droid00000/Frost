# frozen_string_literal: true

module Events
  # An enabled event role.
  class Role
    # @return [Integer] the snowflake ID of the role.
    attr_reader :id

    # @return [Set] the users who can equip the role.
    attr_reader :users

    # @return [Integer] the snowflake ID of the guild.
    attr_reader :guild_id

    # @return [Integer] the UNIX timestamp of when this role was setup.
    attr_reader :setup_by

    # @return [Integer] the ID of the user was responsible for setting up this role.
    attr_reader :setup_at

    # @return [Sequel::Dataset]
    DB = POSTGRES[:event_roles]

    # @return [Sequel::Dataset]
    USERS = POSTGRES[:event_users]

    # @!visibility private
    def initialize(state)
      @users = Set[]
      update_state(state)
    end

    # Delete this role permenantely from the DB.
    def delete
      DB.where(role_id: @id).delete
    end

    # Check if a user has this role.
    # @param user [Integer] The ID of the user to check.
    # @return [true, false] Whether the user has this role.
    def user?(user)
      @users.include?(user.resolve_id)
    end

    # Add users to this role.
    # @param users [Array<Integer>] the user IDs to insert.
    def add_users(users)
      me = users.map { { role_id: @id, user_id: it.resolve_id } }

      users = USERS.returning(:user_id).insert_conflict.multi_insert(me)

      users.each { |inserted_user| @users.add(inserted_user[:user_id]) }
    end

    # Delete users from this role.
    # @param users [Array<Integer>] The user IDs to delete.
    def delete_users(users)
      users = USERS.returning.where(role_id: @id, user_id: users).delete

      users.each { |deleted_user| @users.delete(deleted_user[:user_id]) }
    end

    # @!visibility private
    def self.create(...)
      Storage.pool.create_role(...)
    end

    # @!visibility private
    def self.delete(data)
      Storage.pool.delete_role(guild_id: data.server.id, role_id: data.options["role"])
    end

    # @!visibility private
    def self.get(data, hit: true)
      if data.respond_to?(:options)
        Storage.pool.role(guild_id: data.server.id, role_id: data.options["role"], hit:)
      else
        Storage.pool.role(guild_id: data.server.id, role_id: data.values("role")[0], hit:)
      end
    end

    private

    # @!visibility private
    def update_state(new_data)
      @id = new_data[:role_id]
      @guild_id = new_data[:guild_id]
      @setup_by = new_data[:setup_by]
      @setup_at = new_data[:setup_at]
    end
  end
end
