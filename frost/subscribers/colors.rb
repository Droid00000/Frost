# frozen_string_literal: true

module Boosters
  # Command handler for /booster role gradient.
  def self.colors(data)
    # Check if we can manage roles.
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[47])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    # Check if the invoking user is boosting.
    unless data.user.boosting?
      data.edit_response(content: RESPONSE[8])
      return
    end

    # Check if the invoking user is banned.
    if member.banned?
      data.edit_response(content: RESPONSE[6])
      return
    end

    # Ensure our user doesn't already have a role.
    if member.blank?
      data.edit_response(content: RESPONSE[4])
      return
    end

    data.options.each do |name, value|
      data.options[name] = to_color(value)
    end

    payload = {
      role: member.role,
      reason: REASON[1],
      primary: data.options["first"],
      ternerary: data.options["third"],
      secondary: data.options["second"]
    }.compact

    data.edit_response(content: RESPONSE[2])

    data.server.update_role(**payload) if payload.size > 2
  end
end
