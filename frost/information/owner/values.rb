# frozen_string_literal: true

module Owner
  # Responses and fields for owner commands.
  RESPONSE = {
    1 => "**%s**\nThere have been %s %s in the current lifecycle.\n\n"
    2 => "Success. All emojis have been drained.",
    3 => "**Primitive Garbage Collection Stats**",
    4 => "-# %s total objects since: <t:%s:D>",
    5 => "This command is owner only.",
    6 => "The bot has powered off.",
    7 => "Success! No content.",
    8 => "**Error:** ``%s``",
    9 => "Heads!",
    10 => "``%s``",
    11 => "Tails!"
  }.freeze

  # Mapping of object types to exclude.
  TYPES = {
    FREE: nil,
    TOTAL: nil,
    T_DATA: nil,
    T_MATCH: nil,
    T_IMEMO: nil,
    T_FLOAT: nil,
    T_BIGNUM: nil,
    T_ICLASS: nil,
    T_COMPLEX: nil,
    T_RATIONAL: nil
  }.freeze

  # Application commands for owner commands.
  COMMANDS = {
    1 => "`/coin flip`",
    3 => "`/science`"
  }.freeze

  # Mapping of quotes to escape.
  QUOTES = %w[‘ ’ “ ”].freeze

  # Get the owner of the bot.
  def self.owner
    CONFIG[:Discord][:OWNER]&.to_i
  end

  # Escape curly quotes into straight quotes.
  def self.escape(code)
    code if QUOTES.map { |old| code.gsub!(old, '"') }
  end
end
