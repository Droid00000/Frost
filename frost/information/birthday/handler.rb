# frozen_string_literal: true

require_relative "setup"
require_relative "worker"
require_relative "builder"
require_relative "restart"
require_relative "disable"

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:birthday).group(:admin) do |group|
    group.subcommand("setup") do |event|
      event.defer(ephemeral: true)
      Birthdays.setup(event)
    end

    group.subcommand("disable") do |event|
      event.defer(ephemeral: true)
      Birthdays.disable(event)
    end
  end
end
