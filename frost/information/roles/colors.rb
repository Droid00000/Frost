# frozen_string_literal: true

module AdminCommands
  # Namspace for admin commands.
  module Roles
    # Edit the graident colors for a role.
    def self.colors(data)
      unless data.server.bot.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[2])
        return
      end

      unless data.user.role?(data.options["role"])
        data.edit_response(content: RESPONSE[11])
        return
      end

      # Initalize the invoking role.
      role = Role.new(data.options["role"])

      if role.blank?
        data.edit_response(content: RESPONSE[7])
        return
      end

      # Map to: { name => COLOR || name => :NULL }
      data.options.each do |name, value|
        data.options[name] = if value.match?(REGEX[2])
                               :NULL
                             else
                               to_color(value)
                             end
      end

      payload = {
        role: data.options["role"],
        tertiary: data.options["end"],
        secondary: data.options["start"],
        reason: "Event Roles (ID: #{data.user.id})"
      }.compact

      data.edit_response(content: RESPONSE[1])

      data.server.update_role(**payload) if payload.size > 2
    end
  end
end
