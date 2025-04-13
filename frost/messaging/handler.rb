# frozen_string_literal: true

module PinCommands
  extend Discordrb::EventContainer

  application_command(:archive) do |event|
    event.defer(ephemeral: true)
    Pins.archive(event)
  end

  channel_pins_update do |event|
    Pins.audit(event)
  end
end
