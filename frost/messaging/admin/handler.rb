# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:pin).group(:archiver) do |group|
    group.subcommand("disable") do |event|
      event.defer(ephemeral: true)
      Pins.disable(event)
    end

    group.subcommand("enable") do |event|
      event.defer(ephemeral: true)
      Pins.setup(event)
    end
  end
end
