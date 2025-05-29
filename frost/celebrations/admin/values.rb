# frozen_string_literal: true

module AdminCommands
  # namespace for birthday admins.
  module Birthdays
    # Responses and fields for birthday admins.
    RESPONSE = {
      1 => "The `role` option must be provided when setting up birthday perks.",
      2 => "You need to have the `administrator` permission to do this.",
      3 => "Birthday perks have been successfully disabled.",
      4 => "Birthday perks have been successfully updated.",
      5 => "Birthday perks have been successfully enabled."
    }.freeze

    # Application commands for birthday admins.
    COMMANDS = {
      1 => "`/booster admin disable`",
      2 => "`/booster admin enable`"
    }.freeze
  end
end
