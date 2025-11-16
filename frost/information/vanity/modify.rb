# frozen_string_literal: true

module Vanity
  # Command handler for /vanity role edit.
  def self.edit(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[3])
      return
    end

    options = {
      icon: to_icon(data),
      name: data.options["name"],
      role: data.options["role"],
      reason: "Vanity Roles (ID: #{data.user.id})",
      colour: ::Boosters.to_color(data.options["color"])
    }

    if data.options["icon"]&.match?(REGEX[3])
      options[:icon] = :NULL
    end

    if options[:colour]
      options.merge!(secondary: :NULL, tertiary: :NULL)
    end

    if options.size > 2
      begin
        data.server.update_role(**options.compact)
      rescue Discordrb::Errors::NoPermission
        data.edit_response(content: RESPONSE[1])
        return
      end
    end

    data.edit_response(content: RESPONSE[2])
  end
end
