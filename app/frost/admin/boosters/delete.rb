# frozen_string_literal: true

# Manually removes a user from the database.
def delete_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  unless Frost::Boosters::Settings.get?(data)
    data.edit_response(content: RESPONSE[34])
    return
  end

  unless Frost::Boosters::Members.get?(data, true)
    data.edit_response(content: RESPONSE[27])
    return
  end

  Frost::Boosters::Members.get?(data, true)

  data.edit_response(content: format(RESPONSE[28], data.options['user']))
end
