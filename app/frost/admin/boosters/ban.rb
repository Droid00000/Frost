# frozen_string_literal: true

# Blacklists a user from using booster perks in a server.
def ban_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  if booster_records(server: data.server.id, user: data.options['user'], type: :banned)
    data.edit_response(content: RESPONSE[29])
    return
  end

  booster_records(
    type: :ban,
    server: data.server.id,
    user: data.options['user']
  )

  data.edit_response(content: format(RESPONSE[30], data.options['user']))
end
