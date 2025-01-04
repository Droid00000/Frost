# frozen_string_literal: true

# Manually removes a user from the database.
def delete_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  unless Frost::Boosters::Settings.get(data)
    data.edit_response(content: RESPONSE[34])
    return
  end

  unless Frost::Boosters::Settings.get_user(data)
    data.edit_response(content: RESPONSE[27])
    return
  end

  if Frost::Boosters::Settings.get_ban(data)
    data.edit_response(content: RESPONSE[29])
    return
  end

  Frost::Boosters::Settings.delete_user(data)

  data.edit_response(content: format(RESPONSE[28], data.options["member"]))
end
