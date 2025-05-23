# frozen_string_literal: true

module Emojis
  # Responses and fields for emojis.
  RESPONSE = {
    1 => "These are the currently most used emojis on your server. Non-animated, animated emojis, and reactions are mixed.",
    2 => "The bot needs to have the `manage expressions` permission to do this.",
    3 => "There are no emoji statistics available for this server.",
    4 => "Statistics aren't indexed yet. Try again later.",
    5 => "-# tracking statistics since: 12/2/2024",
    6 => "Added this emoji to the server: %s",
    7 => "### Emoji Statistics for %s"
  }.freeze

  # Application commands for emojis.
  COMMANDS = {
    1 => "`/top emojis`"
  }.freeze
end
