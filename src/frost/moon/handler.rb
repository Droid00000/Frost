# frozen_string_literal: true

require_relative 'phase'

module MoonPhases
  extend Discordrb::EventContainer

  application_command(:moon).subcommand(:phase) do |event|
    event.defer(ephemeral: false)
    moon_phase(event)
  end
end
