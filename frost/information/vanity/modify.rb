# frozen_string_literal: true

module Vanity
  # Command handler for /vanity role edit.
  def self.edit(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[3])
      return
    end

    unless ::Boosters.safe_name?(data)
      data.edit_response(content: RESPONSE[6])
      return
    end

    options = {
      colour: ::Boosters.to_color(data.options["color"]),
      icon: ::Boosters.to_icon(data),
      name: data.options["name"],
      role: data.options["role"],
      reason: reason(data)
    }.compact

    if data.options["icon"]&.match?(REGEX[2])
      options[:icon] = :NULL
    end

    if options[:colour]
      options[:secondary] = :NULL
      options[:tertiary] = :NULL
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
