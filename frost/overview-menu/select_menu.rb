# frozen_string_literal: true

module Frost::Overview
  # Event handler for the bot's settings menu.
  def self.select_menu(event)
    case event.values.first
    when "Owner"
      owner_page(event)
    when "Boosters"
      boosters_page(event)
    when "Birthdays"
      birthdays_page(event)
    end
  end
end
