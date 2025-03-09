# frozen_string_literal: true

require_relative "flipper"
require_relative "manager"
require_relative "evaluate"

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:coin).subcommand(:flip) do |event|
    event.defer(ephemeral: false)
    Owner.flip(event)
  end

  application_command(:shutdown) do |event|
    event.defer(ephemeral: true)
    Owner.shutdown(event)
  end

  application_command(:restart) do |event|
    event.defer(ephemeral: true)
    Owner.restart(event)
  end

  application_command(:eval) do |event|
    event.defer(ephemeral: true)
    Owner.evaluate(event)
  end
end
