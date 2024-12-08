# frozen_string_literal: true

# Manually removes a user from the database.
def delete_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  unless booster_records(server: data.server.id, user: data.options['user'], type: :check_user)
    data.edit_response(content: RESPONSE[27])
    return
  end

  booster_records(
    type: :delete,
    server: data.server.id,
    user: data.options['user']
  )

  data.edit_response(content: format(RESPONSE[28], data.options['user']))
end
