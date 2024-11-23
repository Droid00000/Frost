# frozen_string_literal: true

import 'steal'
import 'info'

module StickerCommands
  extend Discordrb::EventContainer

  application_command(:'add sticker') do |event|
    event.defer(ephemeral: true)
    add_sticker(event)
  end

  application_command(:'view sticker') do |event|
    event.defer(ephemeral: true)
    sticker_info(event)
  end
end
