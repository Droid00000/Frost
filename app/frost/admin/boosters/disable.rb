# frozen_string_literal: true

def disable_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  if data.options["prune"]
    Frost::Boosters::Settings.delete_all(data)
  end

  Frost::Boosters::Settings.disable(data)

  data.edit_response(content: RESPONSE[35])
end
