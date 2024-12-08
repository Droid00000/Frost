# frozen_string_literal: true

# Deletes the pin archiver channel in the database.
def pins_disable(data)
  unless archiver_records(server: data.server.id, type: :get)
    data.edit_response(content: RESPONSE[36])
    return
  end

  archiver_records(server: data.server.id, type: :disable)
  data.edit_response(content: RESPONSE[37])
end
