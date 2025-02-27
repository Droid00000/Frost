# frozen_string_literal: true

module Snowballs
  # Responses and fields for snowballs.
  RESPONSE = {
    1 => "You're out of snowballs! You can collect more using the </collect snowball:1325631057734926339> command!"
    1 => "This command can only be used by contributors.",
    2 => "There aren't enough snowballs to steal.",
    3 => "**%s throws a snowball at %s!**",
    4 => "**%s collected one snowball!**",
    5 => "Stole **%s** snowballs!",
    6 => "**%s missed!**",
    7 => "### COLLECT",
    8 => "### MISS",
    9 => "### HIT",
  }.freeze

  # Application commands for snowballs.
  COMMANDS = {
    1 => "`/collect snowball`",
    2 => "`/throw snowball`",
    3 => "`/steal snowball`"
  }.freeze
end
