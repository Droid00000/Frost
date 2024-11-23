# frozen_string_literal: true

import 'menu'
import 'click'
import 'steal'

module EmojiCommands
  extend Discordrb::EventContainer

  application_command(:'add emoji(s)') do |event|
    event.defer(ephemeral: true)
    create_menu(event)
  end

  application_command(:'add Emojis') do |event|
    event.defer(ephemeral: true)
    steal_emojis(event)
  end

  select_menu do |event|
    event.defer_update
    select_click(event)
  end
end
