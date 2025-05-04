# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    # Responses and fields for booster admins.
    RESPONSE = {
      1 => "Successfully un-banned this user from using booster perks: <@%s>",
      2 => "You must provide a role when initially setting up this feature.",
      3 => "Successfully banned this user from using booster perks: <@%s>",
      4 => "You must have the ``manage roles`` permission to do this.",
      5 => "Successfully updated booster settings for this server.",
      6 => "This user is already banned from using booster perks.",
      7 => "This user is been banned from using booster perks.",
      8 => "Successfully removed <@%s> from being a booster.",
      9 => "Successfully added <@%s> as a booster.",
      10 => "The target user could not be found. ",
      11 => "This user is already a booster."
    }.freeze

    # Application commands for booster admins.
    COMMANDS = {
      1 => "`/booster admin add`",
      2 => "`/booster admin ban`",
      3 => "`/booster admin unban`",
      4 => "`/booster admin delete`",
      5 => "`/booster admin enable`",
      6 => "`/booster admin disable`"
    }.freeze
  end
end
