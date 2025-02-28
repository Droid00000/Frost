# frozen_string_literal: true

module Pins
  # Responses and fields for emojis.
  RESPONSE = {
    2 => "The bot needs to have the ``manage messages`` permission to do this.",
    3 => "A channel must have fifty pins in order to begin archival.",
    3 => "The pin archiver has not been enabled."
  }.freeze

  # Application commands for emojis.
  COMMANDS = {
    1 => "`/archive`"
  }.freeze
end
