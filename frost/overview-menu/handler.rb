# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  button(custom_id: /owner_page_\w+/) do |event|
    event.defer_update
    Frost::Overview.owner_button(event)
  end

  select_menu(custom_id: "settings") do |event|
    event.defer_update
    Frost::Overview.select_menu(event)
  end

  application_command(:info) do |event|
    event.defer(ephemeral: true)
    Frost::Overview.landing_page(event)
  end
end
