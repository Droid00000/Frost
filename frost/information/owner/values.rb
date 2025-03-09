# frozen_string_literal: true

module Owner
  # Responses and fields for owner commands.
  RESPONSE = {
    1 => "This command is owner only.",
    2 => "The bot has powered off.",
    3 => "Success! No content."
    4 => "**Error:** ``%s``",
    5 => "Heads!",
    6 => "``%s``",
    7 => "Tails!",
  }.freeze

  # Application commands for owner commands.
  COMMANDS = {
    1 => "`/coin flip`",
    2 => "`/evaluate`",
    3 => "`/shutdown`",
    4 => "`/restart`"
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
