# frozen_string_literal: true

# Application command handler for /booster role delete.
def delete_role(data)
  unless data.user.boosting?
    data.edit_response(content: RESPONSE[8])
    return
  end

  unless data.server.bot.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[47])
    return
  end

  unless booster_records(server: data.server.id, type: :enabled)
    data.edit_response(content: RESPONSE[5])
    return
  end

  if booster_records(server: data.server.id, user: data.user.id, type: :banned)
    data.edit_response(content: RESPONSE[6])
    return
  end

  unless booster_records(server: data.server.id, user: data.user.id, type: :check_user)
    data.edit_response(content: RESPONSE[9])
    return
  end

  data.server.role(booster_records(server: data.server.id, user: data.user.id, type: :get_role))&.delete(REASON[3])

  booster_records(server: data.server.id, user: data.user.id, type: :delete)

  data.edit_response(content: "#{RESPONSE[3]} #{EMOJI[3]}")
end

# Event handler for the role delete Gateway event.
def role_delete_event(data)
  booster_records(server: data.server.id, role: data.id, type: :delete_role)
end
