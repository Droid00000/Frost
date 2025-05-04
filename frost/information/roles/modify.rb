# frozen_string_literal: true

module AdminCommands
  # Namspace for admin commands.
  module Roles
    # Edit an existing event role.
    def self.edit(data)
      unless data.server.bot.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[47])
        return
      end

      unless data.user.role?(data.options["role"])
        data.edit_response(content: RESPONSE[17])
        return
      end

      unless safe_name?(data.options["name"])
        data.edit_response(content: RESPONSE[7])
        return
      end

      role = Role.new(data.options["role"])

      if role.blank?
        data.edit_response(content: RESPONSE[17])
        return
      end

      payload = {
        icon: resolve_icon(data),
        role: data.options["role"],
        name: data.options["name"],
        colour: resolve_color(data.options["color"]),
        reason: "#{data.user.name} (ID: #{data.user.id})"
      }

      payload.delete(:icon) unless valid_icon?(data, role)

      data.server.update_role(**payload.compact)

      data.edit_response(content: "#{RESPONSE[2]} #{EMOJI[3]}")
    end
  end
end
