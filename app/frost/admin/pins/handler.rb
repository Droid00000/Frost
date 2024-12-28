# frozen_string_literal: true

require_relative "setup"
require_relative "disable"

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:pin).group(:archiver) do |group|
    group.subcommand("setup") do |event|
      event.defer(ephemeral: true)
      pins_setup(event)
    end

    group.subcommand("disable") do |event|
      event.defer(ephemeral: true)
      pins_disable(event)
    end
  end
end
