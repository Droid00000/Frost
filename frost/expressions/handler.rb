# frozen_string_literal: true

module EmojiCommands
  extend Discordrb::EventContainer

  application_command(:top).subcommand(:emojis) do |event|
    event.defer(ephemeral: false)
    Emojis.stats(event)
  end

  message(contains: REGEX[4]) do |event|
    Emojis.cache(event)
  end

  reaction_add do |event|
    Emojis.cache(event)
  end
end
