# frozen_string_literal: true

module ModerationCommands
  extend Discordrb::EventContainer

  application_command(:purge).subcommand(:messages) do |event|
    event.defer(ephemeral: true)
    Moderation.purge(event)
  end

  message(contains: REGEX[2]) do |event|
    Moderation.link(event)
  end

  message(private: false) do |event|
    Moderation.spam(event)
  end
end
