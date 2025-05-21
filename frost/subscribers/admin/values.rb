# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    # Responses and fields for booster admins.
    RESPONSE = {
      1 => "The `icon` option must be provided when setting up booster perks.",
      2 => "The `role` option must be provided when setting up booster perks.",
      3 => "Booster perks must be enabled in order to perform this action.",
      4 => "The target member has been banned from using booster perks.",
      5 => "You need to have the `manage roles` permission to do this.",
      6 => "Booster perks have been successfully disabled.",
      7 => "Booster perks have been successfully updated.",
      8 => "Booster perks have been successfully enabled.",
      9 => "Successfully removed the target booster.",
      10 => "The target member is already a booster.",
      11 => "Successfully added the target booster.",
      12 => "Successfully unbanned the target user.",
      13 => "Successfully banned the target user."
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
