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
    case event.values
    when "MOD"
      help_mod(event)
    when "PINS"
      help_pins(event)
    when "SNOW"
      help_snow(event)
    when "EMOJI"
      help_emoji(event)
    when "BOOST"
      help_booster(event)
    end
  end

  application_command(:help) do |event|
    event.defer(ephemeral: true)
    help_index(event)
  end
end