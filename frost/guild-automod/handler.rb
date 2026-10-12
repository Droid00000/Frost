# frozen_string_literal: true

module ModerationCommands
  extend Discordrb::EventContainer

  message(private: false) do |event|
    Moderation.check_message_spam(event)
  end
end
