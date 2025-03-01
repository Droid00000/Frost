# frozen_string_literal: true

module Birthday
  # Responses and fields for birthday commands.
  RESPONSE = {
    103 => "Your birthday couldn't be found. Please add your birthday using the </birthday add:1334725009427664970> command.",
    105 => "I was unable to process the date or timezone.",
    104 => "This server has not enabled birthday perks.",
    106 => "Successfully deleted your birthday.",
    113 => "Please provide at least one option.",
    107 => "Successfully added your birthday.",
    112 => "You've already set your birthday.",
  }.freeze

  # Default timezones used.
  DEFAULT_ZONES = {
    "New York, United States": "America/New_York",
    "Los Angeles, United States": "America/Los_Angeles",
    "Chicago, United States": "America/Chicago",
    "Denver, United States": "America/Denver",
    "Kolkata, India": "Asia/Kolkata",
    "Istanbul, Türkiye": "Europe/Istanbul",
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
    "São Paulo, Brazil": "America/Sao_Paulo",
    "Tokyo, Japan": "Asia/Tokyo",
    "Shanghai, China": "Asia/Shanghai"
  }.freeze

  # Application commands for birthday commands.
  COMMANDS = {
    1 => "`/birthday delete`",
    2 => "`/birthday edit`",
    3 => "`/birthday set`"
  }.freeze
end
