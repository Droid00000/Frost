# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    # Responses and fields for booster admins.
    RESPONSE = {
      1 => "These are the members who've been banned from using booster perks in this server. Members can be banned with the **/booster admin ban** command, and un-banned with the **/booster admin unban** command."
      2 => "The `icon` option must be provided when setting up booster perks.",
      3 => "The `role` option must be provided when setting up booster perks.",
      4 => "Booster perks must be enabled in order to perform this action.",
      5 => "The target member has been banned from using booster perks.",
      6 => "You need to have the `manage roles` permission to do this.",
      7 => "Booster perks have been successfully disabled.",
      8 => "Booster perks have been successfully updated.",
      9 => "Booster perks have been successfully enabled.",
      10 => "Successfully removed the target booster.",
      11 => "The target member is already a booster.",
      12 => "Successfully added the target booster.",
      13 => "Successfully unbanned the target user.",
      14 => "This server hasn't banned any members.",
      15 => "Successfully banned the target user.",
      16 => "-# viewing %s out of %s members",
      17 => "### Banned Members for %s",
    }.freeze

    # Application commands for booster admins.
    COMMANDS = {
      1 => "`/booster admin disable`",
      2 => "`/booster admin delete`",
      3 => "`/booster admin enable`",
      4 => "`/booster admin unban`",
      5 => "`/booster admin bans`",
      6 => "`/booster admin add`",
      7 => "`/booster admin ban`"
    }.freeze
  end
end
