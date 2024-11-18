# frozen_string_literal: true

require_relative 'create'
require_relative 'steal'
require_relative 'info'

module StickerCommands
  extend Discordrb::EventContainer

  application_command(:create).subcommand(:sticker) do |event|
    event.defer(ephemeral: true)
    create_sticker(event)
  end

  application_command(:'add sticker') do |event|
    event.defer(ephemeral: true)
    add_sticker(event)
  end

  application_command(:'view sticker') do |event|
    event.defer(ephemeral: true)
    view_sticker(event)
  end
end
