# frozen_string_literal: true

module Moderation
  # Responses and fields for moderation.
  RESPONSE = {
    1 => "The bot needs to have the `manage messages` permission to do this.",
    2 => "The bot needs to have the `view channel` permission to do this.",
    3 => "successfully deleted %s message"
  }.freeze

  # Application commands for moderation.
  COMMANDS = {
    1 => "`/purge messages`"
  }.freeze

  # Pluralize a string from the given integer.
  # @param sum [Integer] Any numeric integer.
  def self.plural(sum)
    "#{format(RESPONSE[3], sum)}#{'s' if sum != 1}."
  end
end
