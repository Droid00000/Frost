# frozen_string_literal: true

module ModerationCommands
  extend Discordrb::EventContainer

  application_command(:robomod).subcommand(:configure) do |event|
    Moderation.robomod_configure(event)
  end

  application_command(:robomod).subcommand(:disable) do |event|
    event.defer(ephemeral: true)
    Moderation.robomod_disable(event)
  end

  message(private: false) do |event|
    Moderation.check_message_spam(event)
  end
end
