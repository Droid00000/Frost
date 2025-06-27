# frozen_string_literal: true

module Birthdays
  # Responses and fields for birthday commands.
  RESPONSE = {
    1 => "Your birthday couldn't be found. Please add your birthday using the </birthday add:1386237783747854421> command.",
    2 => "Successfully de-synced your birthday from this server.",
    3 => "Successfully synced your birthday to this server.",
    4 => "This server hasn't enabled birthday perks.",
    5 => "Successfully deleted your birthday.",
    6 => "Successfully updated your birthday.",
    7 => "Successfully added your birthday.",
    8 => "Please provide a valid timezone.",
    9 => "Please provide a valid date."
  }.freeze

  # Default timezones used.
  DEFAULT_ZONES = {
    "New York, United States": "America/New_York",
    "Los Angeles, United States": "America/Los_Angeles",
    "Chicago, United States": "America/Chicago",
    "Denver, United States": "America/Denver",
    "Kolkata, India": "Asia/Kolkata",
    "Istanbul, Turkiye": "Europe/Istanbul",
    "Moscow, Russia": "Europe/Moscow",
    "London, United Kingdom": "Europe/London",
    "Paris, France": "Europe/Paris",
    "Madrid, Spain": "Europe/Madrid",
    "Berlin, Germany": "Europe/Berlin",
    "Athens, Greece": "Europe/Athens",
    "Kyiv, Ukraine": "Europe/Kyiv",
    "Rome, Italy": "Europe/Rome",
    "Amsterdam, Netherlands": "Europe/Amsterdam",
    "Warsaw, Poland": "Europe/Warsaw",
    "Toronto, Canada": "America/Toronto",
    "Brisbane, Australia": "Australia/Brisbane",
    "Sydney, Australia": "Australia/Sydney",
    "Melbourne, Australia": "Australia/Melbourne",
    "Sao Paulo, Brazil": "America/Sao_Paulo",
    "Tokyo, Japan": "Asia/Tokyo",
    "Shanghai, China": "Asia/Shanghai",
    "Lagos, Nigeria": "Africa/Lagos"
  }.freeze
end
