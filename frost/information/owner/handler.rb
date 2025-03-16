# frozen_string_literal: true

require_relative "flipper"
require_relative "science"
require_relative "evaluate"

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:coin).subcommand(:flip) do |event|
    event.defer(ephemeral: false)
    Owner.flip(event)
  end

  application_command(:science) do |event|
    event.defer(ephemeral: true)
    Owner.science(event)
  end

  application_command(:eval) do |event|
    event.defer(ephemeral: true)
    Owner.evaluate(event)
  end
end
