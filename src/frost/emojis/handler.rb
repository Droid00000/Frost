# frozen_string_literal: true

require_relative 'button'
require_relative 'emoji'
require_relative 'steal'

module EmojiCommands
  extend Discordrb::EventContainer

  application_command(:'add emoji(s)') do |event|
    event.defer(ephemeral: true)
    create_emoji(event)
  end

  application_command(:'add emojis') do |event|
    event.defer(ephemeral: true)
    steal_emojis(event)
  end

  button(custom_id: '0') do |event|
    button_click(event, '0')
  end

  button(custom_id: '1') do |event|
    button_click(event, '1')
  end

  button(custom_id: '2') do |event|
    button_click(event, '2')
  end

  button(custom_id: '3') do |event|
    button_click(event, '3')
  end

  button(custom_id: '4') do |event|
    button_click(event, '4')
  end
end
