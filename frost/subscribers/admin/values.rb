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
      6 => "Successfully banned and unbanned the target members.",
      7 => "You must select at least one member to ban or unban.",
      8 => "Booster perks have been successfully disabled.",
      9 => "Booster perks have been successfully updated.",
      10 => "Booster perks have been successfully enabled.",
      11 => "Successfully unbanned the target members.",
      12 => "Successfully removed the target booster.",
      13 => "Successfully banned the target members.",
      14 => "The target member is already a booster.",
      15 => "Successfully added the target booster.",
    }.freeze
  end
end
