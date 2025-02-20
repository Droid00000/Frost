# frozen_string_literal: true

# Adds a new role to the event roles database.
def roles_add(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  Frost::Roles.get?(data) ? Frost::Roles.icon(data) : Frost::Roles.add(data)

  data.edit_response(content: format(RESPONSE[24], data.options["role"]))
end
