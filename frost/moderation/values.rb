# frozen_string_literal: true

module Moderation
  # Responses and fields for moderation.
  RESPONSE = {
    1 => "The bot needs to have the ``manage messages`` permission to do this.",
    2 => "The bot needs to have the ``manage server`` permission to do this.",
    3 => "Invites can only be permanently paused in community servers."
    4 => "The duration cannot be greater than 24 hours.",
    5 => "Successfully disabled invites in this server.",
    6 => "Successfully enabled invites in this server.",
    7 => "This user is too powerful for you to modify.",
    8 => "This user is too powerful for me to modify.",
    9 => "Invites aren't disabled in this server."
    10 => "Successfully updated <@%s> nickname."
    11 => "Successfully deleted %s message.",
    12 => "Please provide a valid duration.",
  }.freeze

  # Application commands for moderation.
  COMMANDS = {
    1 => "`/gatekeeper disable`",
    2 => "`/gatekeeper enable`",
    3 => "`/change nickname`",
    4 => "`/purge messages`"
  }.freeze

  # Pluralize a string from the given integer.
  # @param sum [Integer] Any numeric integer.
  def self.plural(sum)
    "#{format(RESPONSE[11], sum)}#{'s' if sum > 1}"
  end
end
