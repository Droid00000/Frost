# frozen_string_literal: true

# Un-blacklists a user from using booster perks in a server.
def admin_remove_blacklist(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  unless booster_records(server: data.server.id, user: data.options['user'], type: :banned)
    data.edit_response(content: RESPONSE[31])
    return
  end

  booster_records(
    type: :unban,
    server: data.server.id,
    user: data.options['user'],
  )

  data.edit_response(content: format(RESPONSE[32], data.options['user']))
end
