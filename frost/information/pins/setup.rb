# frozen_string_literal: true

module Pins
  # Setup the pin archiver.
  def self.setup(data)
    Frost::Pins.setup(data)

    data.edit_response(content: format(RESPONSE[3], data.options["channel"]))
  end
end
