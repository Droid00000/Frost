# frozen_string_literal: true

module Boosters
  # Command handler for /booster role claim.
  def self.create(data)
    # Check if we can manage roles.
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[47])
      return
    end

    # Check if the invoking user is boosting.
    unless data.member.boosting?
      data.edit_response(content: RESPONSE[8])
      return
    end

    # Make sure we haven't hit the max role limit.
    if data.server.roles.size == 250
      data.edit_response(content: RESPONSE[46])
      return
    end

    # Ensure the {name} parameter is safe.
    unless safe_name?(data.options["name"])
      data.edit_response(content: RESPONSE[7])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    # Check if our invoking server is setup.
    if member.guild.blank?
      data.edit_response(content: RESPONSE[5])
      return
    end

    # Check if the invoking user is banned.
    if member.banned?
      data.edit_response(content: RESPONSE[6])
      return
    end

    # Ensure our user doesn't already have a role.
    unless member.blank?
      data.edit_response(content: RESPONSE[4])
      return
    end

    payload = {
      colour: to_color(data.options["color"]),
      name: data.options["name"],
      mentionable: false,
      reason: REASON[1],
      permissions: 0,
      hoisted: false
    }

    # Remove the icon unless we're able to set it.
    if valid_icon?(data, member.guild)
      payload[:icon] = to_icon(data)
    end

    # Create the actual role here.
    role = data.server.create_role(**payload)

    # Sort the role above our hoist role.
    role.sort_above(member.guild.hoist_role)

    # Add the role to the user here.
    data.user.add_role(role, REASON[1])

    # Insert the role into the DB here.
    user.role = role

    # Return the response here continuing.
    data.edit_response(content: RESPONSE[1])
  end
end
