# frozen_string_literal: true

module ModerationCommands
  extend Discordrb::EventContainer

  application_command(:purge).subcommand(:messages) do |event|
    event.defer(ephemeral: true)
    Moderation.purge(event)
  end

  application_command(:bulk).subcommand(:ban) do |event|
    event.defer(ephemeral: true)
    Moderation.ban(event)
  end
end
