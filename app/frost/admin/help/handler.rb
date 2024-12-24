# frozen_string_literal: true

require_relative 'home'
# require_relative 'pins'
# require_relative 'emoji'
# require_relative 'boosters'
# require_relative 'moderation'

module AdminCommands
  extend Discordrb::EventContainer

  select_menu(custom_id: 'moderation') do |event|
    event.defer_update
    help_mods(event)
  end

  select_menu(custom_id: 'boosters') do |event|
    event.defer_update
    help_booster(event)
  end

  select_menu(custom_id: 'emojis') do |event|
    event.defer_update
    help_emojis(event)
  end

  select_menu(custom_id: 'pins') do |event|
    event.defer_update
    help_pins(event)
  end

  application_command(:help) do |event|
    event.defer(ephemeral: true)
    help_welcome(event)
  end
end
