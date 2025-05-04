# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:event).group(:role) do |group|
    group.subcommand("disable") do |event|
      event.defer(ephemeral: true)
      Roles.disable(event)
    end

    group.subcommand(:enable) do |event|
      event.defer(ephemeral: true)
      Roles.add(event)
    end

    group.subcommand(:edit) do |event|
      event.defer(ephemeral: true)
      Roles.edit(event)
    end
  end
end
