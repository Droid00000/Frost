# frozen_string_literal: true

module Events
  # The cache-layer for events.
  class Storage
    # @return [Sequel::Dataset]
    ROLES = POSTGRES[:event_roles]

    # @return [Sequel::Dataset]
    USERS = POSTGRES[:event_users]

    # @!visibility private
    def initialize
      @roles = {}

      ROLES.order(:setup_at, :role_id).paged_each do |data|
        @roles[data[:role_id]] = Role.new(data)
      end

      USERS.order(:role_id, :user_id).paged_each do |data|
        @roles[data[:role_id]]&.users&.add(data[:user_id])
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

    # Get a single role.
    # @param role_id [Integer] The role ID of the role that should be fetched.
    # @param hit [true, false] Whether to fallback to a database lookup if the role isn't cached.
    # @return [Role, nil] The role that was found during the lookup, or `nil` if it doesn't exist.
    def role(role_id:, hit: false)
      role = @roles[role_id.resolve_id]

      return role if role || hit != true

      role = ROLES.where(role_id: role_id).first
      @roles[data[:role_id]] = Role.new(role) if role
    end

    # Check if a role exists.
    # @param role_id [Integer] The role ID of the role that should be fetched.
    # @param hit [true, false] Whether to fallback to a database lookup if the role isn't cached.
    # @return [true, false] Whether or not the role has been configured to be a role for an event.
    def role?(...)
      !role(...).nil?
    end

    # Delete a role, permanently erasing its settings and users.
    # @param role_id [Integer] The ID of the role that should be deleted.
    # @return [Role, nil] The role that was deleted, or `nil` if there wasn't one to delete.
    def delete_role(role_id:)
      @roles[role_id]&.delete
      @roles&.delete(role_id)
    end

    # Create a role.
    # @param role_id [Integer] The snowflake ID of the role to create.
    # @param guild_id [Integer] The snowflake ID of the guild the role is from.
    # @param setup_at [Integer] The UNIX timestamp of when the role was created.
    # @param setup_by [Integer] The snowflake ID of the user setting up the role to create.
    # @return [Integer] The resulting state of the action that was caused by the operation.
    def create_role(**options)
      options = {
        role_id: options[:role_id],
        guild_id: options[:guild_id],
        setup_by: options[:setup_by],
        setup_at: options[:setup_at]
      }

      role = ROLES.insert_conflict.insert_select(**options)
      role ? 201.tap { @roles[role[:role_id]] = Role.new(role) } : 304
    end
  end
end
