# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:event).group(:role) do |group|
    group.subcommand(:remove) do |event|
      event.defer(ephemeral: true)
      ::Events.delete(event)
    end

    group.subcommand(:claim) do |event|
      event.defer(ephemeral: true)
      ::Events.claim(event)
    end
  end
end
