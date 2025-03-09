# frozen_string_literal: true

module Owner
  # Responses and fields for owner commands.
  RESPONSE = {
    1 => "This command is owner only.",
    2 => "The bot has powered off.",
    3 => "Heads!",
    4 => "Tails!"
  }.freeze

  # Application commands for owner commands.
  COMMANDS = {
    1 => "`/coin flip`",
    2 => "`/evaluate`",
    3 => "`/shutdown`",
    4 => "`/restart`"
  }.freeze
end
