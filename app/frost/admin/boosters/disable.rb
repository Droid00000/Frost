# frozen_string_literal: true

def disable_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  unless Frost::Boosters::Settings.get?(data)
    data.edit_response(content: RESPONSE[34])
    return
  end

  Frost::Boosters::Settings.disable(data)

  data.edit_response(content: RESPONSE[35])
end
