# frozen_string_literal: true

require_relative 'button'
require_relative 'click'
require_relative 'steal'

module EmojiCommands
  extend Discordrb::EventContainer

  application_command(:'add emoji(s)') do |event|
    event.defer(ephemeral: true)
    create_buttons(event)
  end

  application_command(:'add emojis') do |event|
    event.defer(ephemeral: true)
    steal_emojis(event)
  end

  button do |event|
    button_click(event)
  end
end
