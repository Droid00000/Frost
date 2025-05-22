# frozen_string_literal: true

module Emojis
  # Responses and fields for emojis.
  RESPONSE = {
    1 => "These are the currently most used emojis on your server. Non-animated, animated emojis, and reactions are mixed.",
    2 => "The bot needs to have the `manage expressions` permission to do this.",
    3 => "There are no emoji statistics available for this server.",
    4 => "Failed to add emoji. Maximum emoji limit reached.",
    5 => "Statistics aren't indexed yet. Try again later.",
    6 => "-# tracking statistics since: 12/2/2024",
    7 => "Added this emoji to the server: %s",
    8 => "### Emoji Statistics for %s",
    9 => "Emoji file is too large."
  }.freeze

  # Application commands for emojis.
  COMMANDS = {
    1 => "`/create emoji`",
    2 => "`/top emojis`"
  }.freeze

  # Make an emoji error code message.
  # @return [String] The appropriate response.
  def self.code(code)
    code == 501_38 ? RESPONSE[9] : RESPONSE[4]
  end

  # Make an audit-log reason from an action.
  # @return [String] The appropriate reason.
  def self.reason(data)
    "#{data.user.name} (ID: #{data.user.id})"
  end
end
