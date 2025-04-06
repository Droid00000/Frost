# frozen_string_literal: true

module Pins
  # Responses and fields for pins.
  RESPONSE = {
    1 => "The bot needs to have the ``manage messages`` permission to do this.",
    2 => "This channel must have fifty pinned messages to begin archival.",
    3 => "Successfully set the archive channel to: <#%s>",
    4 => "Successfully archived one pinned message.",
    5 => "Successfully disabled the pin archiver.",
    6 => "The pin archiver has not been enabled."
  }.freeze

  # Application commands for pins.
  COMMANDS = {
    1 => "`/pin archiver disable`",
    2 => "`/pin archiver setup`",
    3 => "`/archive`"
  }.freeze
end
