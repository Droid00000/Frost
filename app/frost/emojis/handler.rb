# frozen_string_literal: true

require_relative "menu"
require_relative "audit"
require_relative "drain"
require_relative "stats"
require_relative "click"
require_relative "steal"

module EmojiCommands
  extend Discordrb::EventContainer

  application_command(:drain).subcommand(:emojis) do |event|
    event.defer(ephemeral: true)
    Emojis.drain(event)
  end

  application_command(:emoji).subcommand(:stats) do |event|
    event.defer(ephemeral: false)
    Emojis.stats(event)
  end

  application_command(:"Add Emoji(s)") do |event|
    event.defer(ephemeral: true)
    Emojis.menu(event)
  end

  application_command(:"Add Emojis") do |event|
    event.defer(ephemeral: true)
    Emojis.steal(event)
  end

  select_menu(custom_id: "emoji") do |event|
    event.defer_update
    Emojis.click(event)
  end

  message(contains: REGEX[3]) do |event|
    Emojis.cache(event)
  end

  channel_create do |event|
    Emojis.thread(event)
  end

  reaction_add do |event|
    Emojis.react(event)
  end
end
