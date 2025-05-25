# frozen_string_literal: true

module AdminCommands
  # Namspace for admin commands.
  module Roles
    # Adds a new role to the event roles database.
    def self.add(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[3])
        return
      end

      if data.options["role"].to_i == data.server.id
        data.edit_response(content: RESPONSE[5])
        return
      end

      role = Role.new(data)

      options = {
        guild_id: data.server.id,
        role_id: data.options["role"],
        any_icon: data.options["icon"]
      }

      # Make sure the icon field is given at setup.
      if payload[:any_icon].nil? && role.blank?
        data.edit_response(content: RESPONSE[4])
        return
      end

      role.edit(**options)

      if role.blank?
        data.edit_response(content: RESPONSE[9])
      else
        data.edit_response(content: RESPONSE[10])
      end
    end
  end
end
