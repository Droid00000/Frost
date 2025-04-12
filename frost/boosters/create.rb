# frozen_string_literal: true

module Boosters
  # Command handler for /booster role claim.
  def self.create(data)
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

    # Make sure we haven't hit the max role limit
    # in this server. If so, we can simply return early.
    if data.server.roles.size == 250
      data.edit_response(content: RESPONSE[46])
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

    # Ensure our user doesn't already have a
    # role. If they do, we can simply return early.
    unless member.blank?
      data.edit_response(content: RESPONSE[4])
      return
    end

    payload = {
      colour: to_color(data.options["color"]),
      name: data.options["name"],
      icon: to_icon(data),
      mentionable: false,
      reason: REASON[1],
      permissions: 0,
      hoisted: false
    }

    # Remove the icon unless we're able to set it.
    payload.delete(:icon) unless valid_icon?(data, guild)

    # Create the actual role here.
    role = data.server.create_role(**payload)

    # Add the role to the user here.
    data.user.add_role(role, REASON[1])

    # Sort the role above our hoist role.
    role.sort_above(guild.hoist_role)

    # Insert the role into the DB here.
    user.role = role

    # Return the response here continuing.
    data.edit_response(content: RESPONSE[1])
  end
end
