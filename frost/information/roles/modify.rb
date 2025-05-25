# frozen_string_literal: true

module AdminCommands
  # Namspace for admin commands.
  module Roles
    # Edit an existing event role.
    def self.edit(data)
      unless data.server.bot.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[2])
        return
      end

      unless data.user.role?(data.options["role"])
        data.edit_response(content: RESPONSE[11])
        return
      end

      unless safe_name?(data.options["name"])
        data.edit_response(content: RESPONSE[6])
        return
      end

      role = Role.new(data)

      if role.blank?
        data.edit_response(content: RESPONSE[7])
        return
      end

      options = {
        icon: to_icon(data),
        role: data.options["role"],
        name: data.options["name"],
        colour: resolve_color(data.options["color"]),
        reason: "Event Roles (ID: #{data.user.id})"
      }

      unless valid_icon?(data, role)
        payload.delete(:icon)
      end

      if data.options["icon"]&.match?(REGEX[2])
        payload[:icon] = :NULL
      end

      data.server.update_role(**options.compact)

      data.edit_response(content: RESPONSE[1])
    end
  end
end
