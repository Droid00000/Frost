# frozen_string_literal: true

require_relative "setup"
require_relative "worker"
require_relative "disable"

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:birthday).group(:admin) do |group|
    group.subcommand("setup") do |event|
      event.defer(ephemeral: true)
      setup_birthdays(event)
    end

    group.subcommand("disable") do |event|
      event.defer(ephemeral: true)
      disable_birthdays(event)
    end
  end
end
