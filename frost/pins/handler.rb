# frozen_string_literal: true

require_relative "auto"
require_relative "manual"

module PinArchiver
  extend Discordrb::EventContainer

  application_command(:archive) do |event|
    event.defer(ephemeral: true)
    Pins.archive(event)
  end

  channel_pins_update do |event|
    Pins.audit(event)
  end
end
