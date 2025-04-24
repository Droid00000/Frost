# frozen_string_literal: true

module Boosters
  # Command handler for /booster role claim.
  def self.create(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[47])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[8])
      return
    end

    if data.server.roles.size == 250
      data.edit_response(content: RESPONSE[46])
      return
    end

    unless safe_name?(data.options["name"])
      data.edit_response(content: RESPONSE[7])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    if member.guild.blank?
      data.edit_response(content: RESPONSE[5])
      return
    end

    if member.banned?
      data.edit_response(content: RESPONSE[6])
      return
    end

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

    if valid_icon?(data, member.guild)
      payload[:icon] = to_icon(data)
    end

    role = data.server.create_role(**payload)

    role.sort_above(member.guild.hoist_role)

    data.user.add_role(role, REASON[1])

    user.role = role

    data.edit_response(content: RESPONSE[1])
  end
end
