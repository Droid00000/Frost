# frozen_string_literal: true

# Event handler for the application command /booster role edit.
def edit_role(data)
  unless data.server.bot.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[47])
    return
  end

  unless data.user.boosting?
    data.edit_response(content: RESPONSE[8])
    return
  end

  unless safe_name?(data.options["name"])
    data.edit_response(content: RESPONSE[7])
    return
  end

  unless Frost::Boosters::Settings.get?(data)
    data.edit_response(content: RESPONSE[5])
    return
  end

  unless Frost::Boosters::Members.user?(data)
    data.edit_response(content: RESPONSE[9])
    return
  end

  if Frost::Boosters::Ban.user?(data)
    data.edit_response(content: RESPONSE[6])
    return
  end

  data.server.update_role(
    role: Frost::Boosters::Members.role(data),
    name: data.options["name"],
    colour: resolve_color(data.options["color"]),
    icon: data.emojis("icon")&.static_file,
    reason: REASON[2]
  )

  data.edit_response(content: "#{RESPONSE[2]} #{EMOJI[2]}")
end
