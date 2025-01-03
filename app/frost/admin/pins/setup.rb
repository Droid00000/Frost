# frozen_string_literal: true

def pins_setup(data)
  Frost::Pins.setup(data)

  data.edit_response(content: format(RESPONSE[22], data.options["channel"]))
end
