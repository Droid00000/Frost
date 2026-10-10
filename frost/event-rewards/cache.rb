# frozen_string_literal: true

module EventRoles
  # Cached resources for event roles.
  class Cache
    # @return [Sequel::Dataset]
    ROLES = BOT.db[:event_roles]

    # @return [Sequel::Dataset]
    USERS = BOT.db[:event_users]

    # Fetch all of the data for event roles from the DB.
    # This method must be called before the bot connects to
    # Discord. Make sure to turn off any other bot containers.
    def initialize
      @roles = {}
      @locker = Frost::Locker.new

      ROLES.order(:guild_id, :role_id)
           .paged_each { @roles[it[:role_id]] = Role.new(it) }

      USERS.order(:role_id, :user_id)
           .paged_each { @roles[it[:role_id]]&.push_user(it) }
    end

    # Fetch a single role.
    # @param role_id [Integer, Role] The ID of the role to fetch.
    # @return [EventRoles::Role, nil] The role for the given role ID.
    def fetch_role(role_id)
      @roles[role_id.resolve_id]
    end

    # Delete a single role.
    # @param role_id [Integer, Role] The ID of the role to delete.
    # @return [EventRoles::Role, nil] The role for the given role ID.
    def delete_role(role_id)
      role_id = role_id.resolve_id

      @locker.synchronize(role_id) do
        result = ROLES.where(role_id:).returning(:role_id)

        if result.delete.first&.[](:role_id)
          @roles.delete(role_id)&.tap(:set_tombstone_state)
        end
      end
    end

    # Update a single role.
    # @param role_id [Integer, Role] The ID of the role to update.
    # @param rest [Hash] All of the parameters to update for the role.
    # @return [Hash, nil] The new role-data, or `nil` if the role was deleted.
    def update_role(role_id, rest)
      role_id = role_id.resolve_id

      @locker.synchronize(role_id) do
        result = ROLES.where(role_id:).update(**rest).returning

        @roles[role_id]&.update_state(result[0]) if result.any?
      end
    end

    # Create or update a role.
    # @param id [Integer, Role] The ID of the role to create.
    # @param guild [Guild, Integer] The ID of the guild associated with the role.
    # @return [EventRoles::Role, nil] The role that was created, or `nil` if one already exists.
    def create_role(id:, guild:)
      role_id = id.resolve_id

      values = {
        role_id: role_id,
        features: 0,
        guild_id: guild.resolve_id
      }

      @locker.synchronize(guild_id) do
        result = ROLES
                 .insert_conflict
                 .returning
                 .insert_select(**values)

        return unless result

        if (cached_role = @roles[role_id])
          cached_role.tap { it.update_state(result) }
        else
          @roles[result[:role_id]] = Role.new(result)
        end
      end
    end
  end
end
