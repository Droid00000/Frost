# frozen_string_literal: true

module Boosters
  # Command handler for /booster role edit.
  def self.edit(data)
    # Check if we can manage roles.
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[47])
      return
    end

    # Check if the invoking user is boosting.
    unless data.user.boosting?
      data.edit_response(content: RESPONSE[8])
      return
    end

    # Ensure the {name} parameter is safe.
    unless safe_name?(data.options["name"])
      data.edit_response(content: RESPONSE[7])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

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

    payload = {
      colour: to_color(data.options["color"]),
      name: data.options["name"],
      role: member.role(data),
      icon: to_icon(data),
      reason: REASON[1]
    }.compact

    # Show the response to the user early.
    data.edit_response(content: RESPONSE[2])

    # Remove the icon if it isn't valid.
    unless valid_icon?(data, member.guild)
      payload.delete(:icon)
    end

    # Make the actual request to update the role here.
    data.server.update_role(**payload) if payload.size > 2
  end
end
