# frozen_string_literal: true

module Boosters
  # Command handler for /booster role edit.
  def self.edit(data)
    # Return early unless we have the permission to
    # create and manage roles in this server.
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[47])
      return
    end

    # Return early unless the user is boosting this server.
    unless data.user.boosting?
      data.edit_response(content: RESPONSE[8])
      return
    end

    # Check and make sure the {name} parameter
    # doesn't have any unsafe words in it. If
    # it does, we can simply return early here.
    unless safe_name?(data.options["name"])
      data.edit_response(content: RESPONSE[7])
      return
    end

    # Initalize the booster guild and the user
    # we're operating on for this command.
    guild, member = Guild.new(data), User.new(data)

    # Check if our server is setup. If not, we can
    # simply return early here.
    if guild.blank?
      data.edit_response(content: RESPONSE[5])
      return
    end

    # Check if our user is banned. If so, then
    # we can simply return early here.
    if member.banned?
      data.edit_response(content: RESPONSE[6])
      return
    end

    # Ensure our user already has a role. If they
    # don't we can simply return early.
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
    payload.delete(:icon) unless valid_icon?(data, guild)

    # Make the actual request to update the role here.
    data.server.update_role(**payload) if payload.size > 2
  end
end
