# frozen_string_literal: true

def roles_edit(data)
  unless data.server.bot.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[47])
    return
  end

  unless safe_name?(data.options["name"])
    data.edit_response(content: RESPONSE[7])
    return
  end

  unless data.user.role?(data.options["role"])
    data.edit_response(content: RESPONSE[17])
    return
  end

  unless Frost::Roles.enabled?(data)
    data.edit_response(content: RESPONSE[5])
    return
  end

  unless Frost::Roles.get?(data)
    data.edit_response(content: RESPONSE[17])
    return
  end

  payload = {
    colour: resolve_color(data.options["color"]),
    role: data.options["role"],
    name: data.options["name"],
    icon: resolve_icon(data),
    reason: format(REASON[3], data.user.display_name, data.user.id)
  }

  icon_logic = lambda do
    return true if Frost::Roles.any_icon?(data)

    return true if resolve_icon(data).nil? || resolve_icon(data).is_a?(String)

    data.emojis("icon").server && data.emojis("icon").server.id == data.server.id
  end

  payload.delete(:icon) unless icon_logic.call(data)

  data.server.update_role(**payload)

  data.edit_response(content: "#{RESPONSE[2]} #{EMOJI[3]}")
end
