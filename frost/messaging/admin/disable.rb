# frozen_string_literal: true

module Pins
  # Disable the pin archiver.
  def self.disable(data)
    Guild.new(data, lazy: true).delete

    data.edit_response(content: RESPONSE[5])
  end
end
