# frozen_string_literal: true

module Birthdays
  # Responses and fields for birthday commands.
  RESPONSE = {
    1 => "Your birthday couldn't be found. Please add your birthday using the </birthday add:1334725009427664970> command.",
    2 => "This server has not enabled birthday perks.",
    3 => "Successfully granted the birthday role.",
    4 => "Successfully removed your birthday.",
    5 => "Please provide at least one option.",
    6 => "I failed to process your timezone.",
    7 => "Successfully added your birthday.",
    8 => "You've already set your birthday.",
    9 => "I failed to process your date."
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
    "Shanghai, China": "Asia/Shanghai",
    "Lagos, Nigeria": "Africa/Lagos"
  }.freeze

  # Application commands for birthday commands.
  COMMANDS = {
    1 => "`/birthday delete`",
    2 => "`/birthday grant`",
    3 => "`/birthday edit`",
    4 => "`/birthday sync`",
    5 => "`/birthday add`"
  }.freeze
end
