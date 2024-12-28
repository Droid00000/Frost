# frozen_string_literal: true

# Blacklists a user from using booster perks in a server.
def ban_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  unless Frost::Boosters::Settings.get?(data)
    data.edit_response(content: RESPONSE[34])
    return
  end

  if Frost::Boosters::Ban.user?(data, true)
    data.edit_response(content: RESPONSE[29])
    return
  end

  Frost::Boosters::Members.manual_delete(data)

  data.edit_response(content: format(RESPONSE[30], data.options["user"]))
end
