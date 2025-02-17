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

    if data.server.roles.count == 250
      data.edit_response(content: RESPONSE[46])
      return
    end

    unless safe_name?(data.options["name"])
      data.edit_response(content: RESPONSE[7])
      return
    end

    unless Frost::Boosters::Settings.get(data)
      data.edit_response(content: RESPONSE[5])
      return
    end

    if Frost::Boosters::Members.role(data)
      data.edit_response(content: RESPONSE[4])
      return
    end

    if Frost::Boosters::Ban.user?(data)
      data.edit_response(content: RESPONSE[6])
      return
    end

    payload = {
      colour: resolve_color(data.options["color"]),
      name: data.options["name"],
      icon: resolve_icon(data),
      reason: REASON[1]
    }

    payload.delete(:icon) unless valid_icon?(data)

    role = data.server.create_role(**payload)

    data.user.add_role(role, REASON[1])

    Frost::Boosters::Members.add(data, role)

    role.sort_above(Frost::Boosters::Settings.get(data))

    data.edit_response(content: "#{RESPONSE[1]} #{EMOJI[4]}")
  end
end
