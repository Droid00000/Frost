# frozen_string_literal: true

module AdminCommands
  # Namspace for admin commands.
  module Roles
    # Adds a new role to the event roles database.
    def self.add(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[18])
        return
      end

      payload = {
        guild_id: data.server.id,
        role_id: data.options["role"],
        any_icon: data.options["icon"]
      }

      Roles.add(payload)

      data.edit_response(content: format(RESPONSE[24], data.options["role"]))
    end
  end
end
