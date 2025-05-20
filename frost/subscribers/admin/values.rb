# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    # Responses and fields for booster admins.
    RESPONSE = {
      1 => "Booster perks must be enabled in order to perform this action.",
      2 => "The target member has been banned from using booster perks.",
      3 => "You must have the `manage roles` permission to do this.",
      4 => "Booster perks have been successfully disabled.",
      5 => "Booster perks have been successfully updated.",
      6 => "Successfully removed the target booster.",
      7 => "The target member is already a booster.",
      8 => "Successfully unbanned the target user.",
      9 => "Successfully banned the target user."
    }.freeze

    # Application commands for booster admins.
    COMMANDS = {
      1 => "`/booster admin disable`",
      2 => "`/booster admin delete`",
      3 => "`/booster admin enable`",
      4 => "`/booster admin unban`",
      5 => "`/booster admin add`",
      6 => "`/booster admin ban`",
    }.freeze
  end
end
