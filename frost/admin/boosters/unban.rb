# frozen_string_literal: true

# Un-blacklists a user from using booster perks in a server.
def unban_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  unless Frost::Boosters::Settings.get(data)
    data.edit_response(content: RESPONSE[34])
    return
  end

  Frost::Boosters::Ban.remove(data)

  data.edit_response(content: format(RESPONSE[32], data.options["member"]))
end
