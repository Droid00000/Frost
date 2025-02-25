# frozen_string_literal: true

require_relative "admin"
require_relative "members"
require_relative "paginator"

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:house).subcommand(:members) do |event|
    event.defer(ephemeral: false)
    members_house(event)
  end

  select_menu(custom_id: "Houses") do |event|
    event.defer_update
    admin_house(event)
  end

  button(custom_id: REGEX[6]) do |event|
    event.defer_update
    members_page(event)
  end

  button(custom_id: REGEX[7]) do |event|
    event.defer_update
    staff_page(event)
  end
end
