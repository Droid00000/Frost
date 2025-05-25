# frozen_string_literal: true

module Boosters
  # Command handler for /booster role edit.
  def self.edit(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[6])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[9])
      return
    end

    unless safe_name?(data.options["name"])
      data.edit_response(content: RESPONSE[8])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    if member.blank? || !data.server.role(member.role)
      data.edit_response(content: RESPONSE[2])
      return
    end

    if member.banned?
      data.edit_response(content: RESPONSE[7])
      return
    end

    payload = {
      colour: to_color(data.options["color"]),
      name: data.options["name"],
      role: member.role(data),
      reason: reason(data)
    }.compact

    data.edit_response(content: RESPONSE[4])

    if valid_icon?(data, member.guild)
      payload[:icon] = to_icon(data)
    end

    if data.options["icon"]&.match?(REGEX[2])
      payload[:icon] = :NULL
    end

    data.server.update_role(**payload) if payload.size > 2
  end
end
