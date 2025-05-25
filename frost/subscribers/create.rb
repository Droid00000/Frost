# frozen_string_literal: true

module Boosters
  # Command handler for /booster role claim.
  def self.create(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[6])
      return
    end

    #unless data.user.boosting?
    #  data.edit_response(content: RESPONSE[9])
    #  return
    #end

    if data.server.roles.size == 250
      data.edit_response(content: RESPONSE[5])
      return
    end

    unless safe_name?(data.options["name"])
      data.edit_response(content: RESPONSE[8])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    unless member.blank?
      data.edit_response(content: RESPONSE[11])
      return
    end

    if member.guild.blank?
      data.edit_response(content: RESPONSE[10])
      return
    end

    if member.banned?
      data.edit_response(content: RESPONSE[7])
      return
    end

    payload = {
      colour: to_color(data.options["color"]),
      name: data.options["name"],
      reason: reason(data),
      mentionable: false,
      permissions: 0,
      hoist: false
    }

    if valid_icon?(data, member.guild)
      payload[:icon] = to_icon(data)
    end

    role = data.server.create_role(**payload)

    role.sort_above(member.guild.hoist_role)

    data.user.add_role(role, reason(data))

    member.role = role.resolve_id

    data.edit_response(content: RESPONSE[1])
  end
end
