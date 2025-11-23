# frozen_string_literal: true

module Events
  # An enabled event role.
  class Role
    # @return [Integer] the ID of the role this model is for.
    attr_reader :id

    # @return [Integer] the ID of the guild this model is for.
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

    # Fetch the users who have this role.
    # @return [Set] The user IDs for this role.
    def users
      return @users if @listed

      @users = list_users.to_set.tap { @listed = true }
    end

    # Delete this role permenantely from the DB.
    def delete
      DB.where(guild_id: guild_id, role_id: id).delete
    end

    # Delete users from this role.
    # @param users [Array<Integer>] The user IDs to delete.
    def delete_users(users:)
      me = {
        role_id: id,
        guild_id: guild_id
      }

      @users.subtract(users.map(&:to_i))

      USERS.where(**me, user_id: users).delete
    end

    # Add users to this role.
    # @param users [Array<Integer>] the user IDs to insert.
    def add_users(users:)
      me = users.map do |user|
        {
          role_id: id,
          user_id: user.to_i,
          guild_id: guild_id
        }
      end

      @users.add(users.map(&:to_i))

      USERS.insert_conflict.multi_insert(me)
    end

    # Check if a user has this role.
    # @param user [Integer] The ID of the user to check.
    # @return [true, false] Whether the user has this role.
    def user?(user:)
      return @users.any?(user.to_i) if @listed

      me = { role_id: id, guild_id: guild_id }

      USERS.where(user_id: user.to_i, **me).any?
    end

    # @!visibility private
    def self.create(...)
      Layer.pool.create_role(...)
    end

    # @!visibility private
    def self.delete(data)
      Layer.pool.delete_role(guild_id: data.server.id, role_id: data.options["role"])
    end

    # @!visibility private
    def self.get(data, hit: true)
      if data.respond_to?(:options)
        Layer.pool.role(guild_id: data.server.id, role_id: data.options["role"], hit:)
      else
        Layer.pool.role(guild_id: data.server.id, role_id: data.values("role")[0], hit:)
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

    # @!visibility private
    def list_users
      query = <<~SQL
        SELECT user_id AS id FROM event_users
        WHERE role_id = ? AND guild_id = ? ORDER BY user_id DESC;
      SQL

      POSTGRES[query, id, guild_id].paged_each(strategy: :filter).map { it[:id] }
    end
  end
end
