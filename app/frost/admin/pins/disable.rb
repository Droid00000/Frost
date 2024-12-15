# frozen_string_literal: true

# Deletes the pin archiver channel in the database.
def pins_disable(data)
  unless Frost::Pins.get(data)
    data.edit_response(content: RESPONSE[36])
    return
  end

  Frost::Pins.disable(data)
  data.edit_response(content: RESPONSE[37])
end
