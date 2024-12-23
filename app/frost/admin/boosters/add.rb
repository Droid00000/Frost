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

  if Frost::Boosters::Ban.user?(data, true)
    data.edit_response(content: RESPONSE[29])
    return
  end

  Frost::Boosters::Members.manual_add(data)

  data.edit_response(content: format(RESPONSE[26], data.options['user']))
end
