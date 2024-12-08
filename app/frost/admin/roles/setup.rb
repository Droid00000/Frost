# frozen_string_literal: true

# Adds a new role to the event roles database.
def roles_setup(data)
  if event_records(server: data.server.id, role: data.options['role'], type: :check_role)
    data.edit_response(content: RESPONSE[23])
    return
  end

  event_records(
    type: :register_role,
    server: data.server.id,
    role: data.options['role']
  )

  data.edit_response(content: format(RESPONSE[24], data.options['role']))
end
