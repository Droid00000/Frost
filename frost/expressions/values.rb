# frozen_string_literal: true

module Emojis
  # Responses and fields for emojis.
  RESPONSE = {
    1 => "These are the current top emojis for your server. Non-animated, animated emojis, and reactions are mixed. If you enjoy using the bot, please consider supporting its development.",
    2 => "The bot needs to have the ``manage expressions`` permission to do this.",
    3 => "Failed to add emoji. Maximum emoji limit reached.",
    4 => "This message does not contain any emojis.",
    7 => "Viewing %s out of %s cached emojis.",
    8 => "Select the Emojis you want to add!",
    9 => "Added this emoji to the server:",
    10 => "### Emoji Statistics for %s",
    11 => "Unable to drain emojis."
  }.freeze

  # Application commands for emojis.
  COMMANDS = {
    1 => "`/add emoji(s)`",
    2 => "`/add emojis`",
    3 => "`/top emojis`"
  }.freeze
end
