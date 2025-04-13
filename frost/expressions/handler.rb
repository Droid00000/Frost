# frozen_string_literal: true

module EmojiCommands
  extend Discordrb::EventContainer

  application_command(:create).subcommand(:emoji) do |event|
    event.defer(ephemeral: true)
    Emojis.add(event)
  end

  application_command(:top).subcommand(:emojis) do |event|
    event.defer(ephemeral: false)
    Emojis.stats(event)
  end

  application_command(:"Add Emojis") do |event|
    event.defer(ephemeral: true)
    Emojis.menu(event)
  end

  select_menu(custom_id: "emoji") do |event|
    event.defer_update
    Emojis.add(event)
  end

  message(contains: REGEX[2]) do |event|
    Emojis.cache(event)
  end

  reaction_add do |event|
    Emojis.cache(event)
  end
end
