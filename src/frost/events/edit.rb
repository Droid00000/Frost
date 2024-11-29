# frozen_string_literal: true

def edit_event_role(data)
  unless data.server.bot.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[47])
    return
  end

  unless safe_name?(data.options['name'])
    data.edit_response(content: RESPONSE[7])
    return
  end

  unless data.user.role?(data.options['role'])
    data.edit_response(content: RESPONSE[17])
    return
  end

  unless event_records(server: data.server.id, type: :enabled)
    data.edit_response(content: RESPONSE[5])
    return
  end

  unless event_records(server: data.server.id, role: data.options['role'], type: :check_role)
    data.edit_response(content: RESPONSE[17])
    return
  end

  data.server.update_role(
    role: data.options['role'],
    name: data.options['name'],
    colour: resolve_color(data.options['color']),
    icon: data.emojis('icon')&.file,
    reason: REASON[5]
  )

  data.edit_response(content: "#{RESPONSE[2]} #{EMOJI[3]}")
end
