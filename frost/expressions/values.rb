# frozen_string_literal: true

module Emojis
  # Responses and fields for emojis.
  RESPONSE = {
    1 => "These are the current top emojis for your server. Non-animated, animated emojis, and reactions are mixed. If you enjoy using the bot, please consider supporting its development.",
    2 => "The bot needs to have the ``manage expressions`` permission to do this.",
    3 => "Failed to add emoji. Maximum emoji limit reached.",
    4 => "-# Tracking statistics since: <t:1733179380:d>",
    5 => "This message does not contain any emojis.",
    6 => "Select the Emojis you want to add!",
    7 => "Added this emoji to the server: %s",
    8 => "### Emoji Statistics for %s",
    9 => "Emoji file is too large.",
    10 => "Unable to drain emojis."
  }.freeze

  # Application commands for emojis.
  COMMANDS = {
    1 => "`/create emoji`",
    2 => "`/add emojis`",
    3 => "`/top emojis`"
  }.freeze

  # Make an emoji error code message.
  # @return [String] The appropriate response.
  def self.code(code)
    code == 501_38 ? RESPONSE[11] : RESPONSE[3]
  end
end
