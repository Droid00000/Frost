# frozen_string_literal: true

def disable_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end
  
  Frost::Boosters::Bans.cascade(data)

  Frost::Boosters::Settings.disable(data)

  Frost::Boosters::Settings.cascase(data)

  data.edit_response(content: RESPONSE[35])
end
