# frozen_string_literal: true

module Pins
  # Disable the pin archiver.
  def self.disable(data)
    Frost::Pins.disable(data)

    data.edit_response(content: RESPONSE[5])
  end
end
