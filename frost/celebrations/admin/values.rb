# frozen_string_literal: true

module AdminCommands
  # namespace for birthday admins.
  module Birthdays
    # Responses and fields for birthday admins.
    RESPONSE = {
      1 => "**Happy Birthday <@%s>!**\n\nI hope you have an amazing one, thanks for spending some time with us! <:DevsGrandson:1334337064317095936>",
      2 => "The `role` option must be provided when setting up birthday perks.",
      3 => "You need to have the `administrator` permission to do this.",
      4 => "Birthday perks have been successfully disabled.",
      5 => "Birthday perks have been successfully updated.",
      6 => "Birthday perks have been successfully enabled."
    }.freeze
  end
end
