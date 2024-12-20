# frozen_string_literal: true

# Manually adds a user to the database.
def add_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  unless Frost::Boosters::Settings.get?(data)
    data.edit_response(content: RESPONSE[34])
    return
  end

  if Frost::Boosters::Members.get?(data, true)
    data.edit_response(content: RESPONSE[25])
    return
  end

  Frost::Boosters::Members.add(data, nil, true)

  data.edit_response(content: format(RESPONSE[26], data.options['user']))
end
