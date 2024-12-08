# frozen_string_literal: true

def disable_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  unless booster_records(server: data.server.id, type: :enabled)
    data.edit_response(content: RESPONSE[34])
    return
  end

  booster_records(server: data.server.id, type: :disable)

  data.edit_response(content: RESPONSE[35])
end
