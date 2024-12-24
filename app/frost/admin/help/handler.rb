# frozen_string_literal: true

require_relative 'pins'
require_relative 'index'
# require_relative 'emoji'
# require_relative 'boosters'
# require_relative 'moderation'

module AdminCommands
  extend Discordrb::EventContainer

  select_menu(custom_id: 'index') do |event|
    event.defer_update
    help_pins(event)
  end

  application_command(:help) do |event|
    event.defer(ephemeral: true)
    help_index(event)
  end
end
