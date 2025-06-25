# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:vanity).group(:role) do |group|
    group.subcommand(:gradient) do |event|
      event.defer(ephemeral: false)
      Roles.colors(event)
    end

    group.subcommand(:disable) do |event|
      event.defer(ephemeral: true)
      Roles.disable(event)
    end

    group.subcommand(:enable) do |event|
      event.defer(ephemeral: true)
      Roles.setup(event)
    end

    group.subcommand(:edit) do |event|
      event.defer(ephemeral: false)
      Roles.edit(event)
    end
  end
end
