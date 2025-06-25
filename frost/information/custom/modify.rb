# frozen_string_literal: true

module Roles
  # Command handler for /vanity role edit.
  def self.edit(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[3])
      return
    end

    unless safe_name?(data.options["name"])
      data.edit_response(content: RESPONSE[7])
      return
    end

    options = {
      colour: to_color(data.options["color"]),
      name: data.options["name"],
      role: data.options["role"],
      reason: reason(data),
      icon: to_icon(data)
    }.compact

    if data.options["icon"]&.match?(REGEX[2])
      options[:icon] = :NULL
    end

    if options[:colour]
      options[:secondary] = :NULL
      options[:tertiary] = :NULL
    end

    unless exempt?(data.user, Guild.new(data))
      data.edit_response(content: RESPONSE[6])
      return
    end

    if options.size > 2
      begin
        data.server.update_role(**options)
      rescue Discordrb::Errors::NoPermission
        data.edit_response(content: RESPONSE[1])
        return
      end
    end

    data.edit_response(content: RESPONSE[2])
  end
end
