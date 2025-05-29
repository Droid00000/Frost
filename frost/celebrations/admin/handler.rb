# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:birthday).group(:admin) do |group|
    group.subcommand(:disable) do |event|
      event.defer(ephemeral: true)
      Birthdays.disable(event)
    end

    group.subcommand(:enable) do |event|
      event.defer(ephemeral: true)
      Birthdays.setup(event)
    end
  end
end
