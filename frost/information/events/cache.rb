# frozen_string_literal: true

module Events
  # The cache-layer for events.
  class Storage
    # @return [Sequel::Dataset]
    ROLES = POSTGRES[:event_roles]

    # @!visibility private
    def initialize
      @roles = {}

      ROLES.order(:role_id).paged_each do |data|
        @roles[data[:role_id]] = Role.new(data)
      end

      roles.each_value(&:users)
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

    # Get a role from the real-time layer.
    # @param role_id [Integer] The role ID of the role that should be fetched.
    # @param hit [true, false] Whether to fallback to a database lookup if the role isn't cached.
    # @return [Role, nil] The role that was found during the lookup, or `nil` if it doesn't exist.
    def role(role_id:, hit: false)
      role = @roles[role_id.resolve_id]

      return role if role || hit != true

      role = ROLES.where(role_id: role_id).first
      @roles[data[:role_id]] = Role.new(role) if role
    end

    # Check if a role exists at the real-time layer.
    # @param role_id [Integer] The role ID of the role that should be fetched.
    # @param hit [true, false] Whether to fallback to a database lookup if the role isn't cached.
    # @return [true, false] Whether or not the role has been configured to be a role for an event.
    def role?(...)
      !role(...).nil?
    end

    # Delete a role, permanently erasing its settings and members.
    # @param role_id [Integer] The ID of the role that should be deleted.
    # @return [Role, nil] The role that was deleted, or `nil` if there wasn't one to delete.
    def delete_role(role_id:)
      @roles.delete(role_id.resolve_id)&.tap(&:delete)
    end

    # Create a role on the real-time layer.
    # @param role_id [Integer] The snowflake ID of the role to create.
    # @param guild_id [Integer] The snowflake ID of the guild the role is from.
    # @param setup_at [Integer] The UNIX timestamp of when the role was created.
    # @param setup_by [Integer] The snowflake ID of the user setting up the role to create.
    # @return [Integer] The resulting state of the action that was caused by the operation.
    def create_role(**options)
      return 304 if role(role_id: options[:role_id])

      options = {
        role_id: options[:role_id],
        guild_id: options[:guild_id],
        setup_by: options[:setup_by],
        setup_at: options[:setup_at]
      }

      role = ROLES.insert_conflict.insert_select(options)
      201.tap { @roles[role[:role_id]] = Role.new(role) } if role
    end
  end
end
