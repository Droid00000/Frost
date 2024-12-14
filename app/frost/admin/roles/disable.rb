# frozen_string_literal: true

# Disabled the event perks functionality for this server.
def roles_disable(data)
  unless Frost::Roles.enabled?(data)
    data.edit_response(content: RESPONSE[38])
    return
  end

  Frost::Roles.disable(data)
  data.edit_response(content: RESPONSE[39])
end
