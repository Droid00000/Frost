# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  modal_submit(custom_id: "owner_page_evaluate") do |event|
    event.defer(ephemeral: true)
    Frost::Overview.evaluate_modal_submit(event)
  end

  button(custom_id: "owner_page_evaluate") do |event|
    Frost::Overview.owner_page_evaluate(event)
  end

  button(custom_id: "owner_page_shutdown") do |event|
    event.defer_update
    Frost::Overview.owner_page_shutdown(event)
  end

  button(custom_id: "owner_page_restart") do |event|
    event.defer_update
    Frost::Overview.owner_page_restart(event)
  end

  button(custom_id: "owner_page_logging") do |event|
    event.defer_update
    Frost::Overview.owner_page_logging(event)
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
