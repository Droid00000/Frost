# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    # Responses and fields for booster admins.
    RESPONSE = {
      2 => "The `icon` option must be provided when setting up booster perks.",
      3 => "The `role` option must be provided when setting up booster perks.",
      4 => "Booster perks must be enabled in order to perform this action.",
      5 => "The target member has been banned from using booster perks.",
      6 => "You need to have the `manage roles` permission to do this.",
      7 => "Booster perks have been successfully disabled.",
      8 => "Booster perks have been successfully updated.",
      9 => "Booster perks have been successfully enabled.",
      11 => "Successfully removed the target booster.",
      12 => "The target member is already a booster.",
      13 => "Successfully added the target booster.",
      14 => "Successfully unbanned the target member.",
      15 => "Successfully banned the target member."
    }.freeze
  end
end
