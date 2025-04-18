# frozen_string_literal: true

module Owner
  # Responses and fields for owner commands.
  RESPONSE = {
    1 => "Success. All emojis have been drained.",
    2 => "This command is owner only.",
    3 => "The bot has powered off.",
    4 => "Success! No content.",
    5 => "**Error:** ``%s``",
    6 => "Heads!",
    7 => "``%s``",
    8 => "Tails!"
  }.freeze

  # Application commands for owner commands.
  COMMANDS = {
    1 => "`/coin flip`",
    3 => "`/science`"
  }.freeze

  # Mapping of smart quotes to escape.
  QUOTES = %w[‘ ’ “ ”].freeze

  # Escape curly quotes into straight quotes.
  def self.escape(code)
    code if QUOTES.map { |old| code.gsub!(old, '"') }
  end
end
