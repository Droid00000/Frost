# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:event).group(:admin) do |group|
    group.subcommand(:add) do |event|
      event.defer(ephemeral: true)
      Events.add(event)
    end

    group.subcommand(:disable) do |event|
      event.defer(ephemeral: true)
      Events.disable(event)
    end

    group.subcommand(:enable) do |event|
      event.defer(ephemeral: true)
      Events.setup(event)
    end

    group.subcommand(:delete) do |event|
      event.defer(ephemeral: true)
      Events.delete(event)
    end
  end
end
