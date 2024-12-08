# frozen_string_literal: true

# Manually adds a user to the database.
def add_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  if booster_records(server: data.server.id, user: data.options['user'], type: :check_user)
    data.edit_response(content: RESPONSE[25])
    return
  end

  booster_records(
    type: :create,
    server: data.server.id,
    user: data.options['user'],
    role: data.options['role']
  )

  data.edit_response(content: format(RESPONSE[26], data.options['user']))
end
