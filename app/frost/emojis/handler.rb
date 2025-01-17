# frozen_string_literal: true

require_relative "menu"
require_relative "drain"
require_relative "stats"
require_relative "click"
require_relative "steal"

module EmojiCommands
  extend Discordrb::EventContainer

  application_command(:drain).subcommand(:emojis) do |event|
    event.defer(ephemeral: true)
    drain_emojis(event)
  end

  application_command(:emoji).subcommand(:stats) do |event|
    event.defer(ephemeral: false)
    stats_command(event)
  end

  application_command(:"Add Emoji(s)") do |event|
    event.defer(ephemeral: true)
    create_menu(event)
  end

  application_command(:"Add Emojis") do |event|
    event.defer(ephemeral: true)
    steal_emojis(event)
  end

  select_menu(custom_id: "emoji") do |event|
    event.defer_update
    select_click(event)
  end

  message(contains: REGEX[3]) do |event|
    emoji_stats(event)
  end

  channel_create do |event|
    thread_join(event)
  end

  reaction_add do |event|
    emoji_react(event)
  end
end
