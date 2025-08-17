# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:vanity).group(:role) do |group|
    group.subcommand(:gradient) do |event|
      event.defer(ephemeral: false)
      Vanity.colors(event)
    end

    group.subcommand(:edit) do |event|
      event.defer(ephemeral: false)
      Vanity.edit(event)
    end
  end
end
