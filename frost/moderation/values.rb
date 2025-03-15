# frozen_string_literal: true

module Moderation
  # Responses and fields for moderation.
  RESPONSE = {
    1 => "The bot needs to have the ``manage messages`` permission to do this.",
    2 => "The bot needs to have the ``manage server`` permission to do this.",
    3 => "Successfully deleted %s message.",
  }.freezex

  # Application commands for moderation.
  COMMANDS = {
    1 => "`/gatekeeper disable`",
    2 => "`/gatekeeper enable`",
    3 => "`/change nickname`",
    4 => "`/purge messages`"
  }.freeze

  # Pluralize a string from the given integer.
  # @param sum [Integer] Any numeric integer.
  def plural(sum)
    "#{format(RESPONSE[3], sum)}#{'s' if sum > 1}"
  end
end
