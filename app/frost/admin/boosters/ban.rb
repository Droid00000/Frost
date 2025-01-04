# frozen_string_literal: true

# Blacklists a user from using booster perks in a server.
def ban_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  unless Frost::Boosters::Settings.get(data)
    data.edit_response(content: RESPONSE[34])
    return
  end

  Frost::Boosters::Ban.add(data)

  Frost::Boosters::Members.delete_user(data)

  data.edit_response(content: format(RESPONSE[30], data.options["member"]))
end
