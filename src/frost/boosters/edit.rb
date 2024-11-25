# frozen_string_literal: true

# Event handler for the application command /booster role edit.
def edit_role(data)
  if booster_records(server: data.server.id, user: data.user.id, type: :banned)
    data.edit_response(content: RESPONSE[6])
    return
  end

  unless booster_records(server: data.server.id, user: data.user.id, type: :check_user)
    data.edit_response(content: RESPONSE[9])
    return
  end

  unless data.bot.profile.on(data.server).permission?(:manage_roles)
    data.edit_response(content: RESPONSE[47])
    return
  end

  unless booster_records(server: data.server.id, type: :enabled)
    data.edit_response(content: RESPONSE[5])
    return
  end

  unless data.user.boosting?
    data.edit_response(content: RESPONSE[8])
    return
  end

  unless safe_name?(data.options['name'])
    data.edit_response(content: RESPONSE[7])
    return
  end

  data.server.update_role(
    role: booster_records(server: data.server.id, user: data.user.id, type: :get_role),
    name: data.options['name'],
    colour: resolve_color(data.options['color']),
    icon: data.emojis('icon')&.file,
    reason: REASON[2]
  )

  data.edit_response(content: "#{RESPONSE[2]} #{EMOJI[2]}")
end
