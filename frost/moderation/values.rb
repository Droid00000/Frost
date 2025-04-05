# frozen_string_literal: true

module Moderation
  # Responses and fields for moderation.
  RESPONSE = {
    1 => "The bot needs to have the ``manage messages`` permission to do this.",
    2 => "This user is too powerful for you to modify.",
    3 => "This user is too powerful for me to modify.",
    4 => "Successfully updated <@%s> nickname.",
    5 => "Successfully deleted %s message.",
  }.freeze

  # Application commands for moderation.
  COMMANDS = {
    1 => "`/change nickname`",
    2 => "`/purge messages`"
  }.freeze

  # Get the postion of a user's highest role.
  # @param member [Member] The user to operate on.
  # @return [Integer] Position of the highest role.
  def self.hierarchy(member)
    member.highest_role.position
  end

  # Pluralize a string from the given integer.
  # @param sum [Integer] Any numeric integer.
  def self.plural(sum)
    "#{format(RESPONSE[11], sum)}#{'s' if sum != 1}"
  end
end
