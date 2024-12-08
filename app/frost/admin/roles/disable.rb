# frozen_string_literal: true

# Disabled the event perks functionality for this server.
def roles_disable(data)
  unless event_records(server: data.server.id, type: :enabled)
    data.edit_response(content: RESPONSE[38])
    return
  end

  event_records(server: data.server.id, type: :disable)
  data.edit_response(content: RESPONSE[39])
end
