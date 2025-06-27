# frozen_string_literal: true

module General
  # Responses and fields for general commands.
  RESPONSE = {
    1 => "The bot needs to have the `manage messages` permission to do this.",
    2 => "The bot needs to have the `view channel` permission to do this.",
    3 => "Successfully deleted %s message",
    4 => "Invalid timezone."
  }.freeze

  # Pluralize a string from the given integer.
  # @param string [String] The string to format.
  # @param sum [Integer] Any numeric integer.
  def self.plural(string, sum)
    "#{format(string, sum)}#{'s' if sum != 1}."
  end
end
