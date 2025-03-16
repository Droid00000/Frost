# frozen_string_literal: true

module Owner
  # Responses and fields for owner commands.
  RESPONSE = {
    1 => "Success. All emojis have been drained.",
    2 => "This command is owner only.",
    3 => "The bot has powered off.",
    4 => "Success! No content."
    5 => "**Error:** ``%s``",
    6 => "Heads!",
    7 => "``%s``",
    8 => "Tails!",
  }.freeze

  # Application commands for owner commands.
  COMMANDS = {
    1 => "`/coin flip`",
    2 => "`/evaluate`",
    3 => "`/science`"
  }.freeze

  # Mapping of quotes to escape.
  QUOTES = {
    "‘" => "\"",
    "’" => "\"",
    "“" => "\"",
    "”" => "\""
  }.freeze

  # Escape curly quotes into straight quotes.
  def self.escape(code)
    QUOTES.map { |old, new| code.gsub!(old, new) }
  end
end
