# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  select_menu(custom_id: /settings/) do |event|
    event.defer_update
    Settings.menu(event)
  end

  application_command(:info) do |event|
    event.defer(ephemeral: true)
    Settings.info(event)
  end
end
