# frozen_string_literal: true

import 'menu'
import 'stats'
import 'click'
import 'steal'

module EmojiCommands
  extend Discordrb::EventContainer

  application_command(:'Add Emoji(s)') do |event|
    event.defer(ephemeral: true)
    create_menu(event)
  end

  application_command(:'Add Emojis') do |event|
    event.defer(ephemeral: true)
    steal_emojis(event)
  end

  select_menu(custom_id: 'emojis') do |event|
    event.defer_update
    select_click(event)
  end

  message(contains: REGEX[3]) do |event|
    emoji_stats(event)
  end
end