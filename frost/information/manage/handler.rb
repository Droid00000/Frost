# frozen_string_literal: true

require_relative "index"
require_relative "custom"
require_relative "values"
require_relative "booster"
require_relative "archiver"
require_relative "birthday"

module AdminCommands
  extend Discordrb::EventContainer

  select_menu(custom_id: "settings") do |event|
    event.defer_update
    Settings.menu(event)
  end

  application_command(:info) do |event|
    event.defer(ephemeral: true)
    Settings.info(event)
  end
end
