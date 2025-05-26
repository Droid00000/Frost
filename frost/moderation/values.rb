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
    1 => "`/purge messages`",
    2 => "`/bulk ban`"
  }.freeze

  # Get the postion of a user's highest role.
  # @param member [Member] The user to operate on.
  # @return [Integer] Position of the highest role.
  def self.hierarchy(member)
    member.highest_role.position
  end

  # Pluralize a string from the given integer.
  # @param string [String] The string to format.
  # @param sum [Integer] Any numeric integer.
  def self.plural(string, sum)
    "#{format(string, sum)}#{'s' if sum != 1}."
  end
end
