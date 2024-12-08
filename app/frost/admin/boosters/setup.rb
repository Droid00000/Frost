# frozen_string_literal: true

# Setup booster perks for a server, or update them.
def setup_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  if booster_records(server: data.server.id, type: :enabled)
    booster_records(
      server: data.server.id,
      role: data.options['role'],
      type: :update_hoist_role
    )
  else
    booster_records(
      type: :setup,
      server: data.server.id,
      role: data.options['role']
    )
  end

  data.edit_response(content: format(RESPONSE[33], data.options['role']))
end
