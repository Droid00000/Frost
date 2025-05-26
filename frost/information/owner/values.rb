# frozen_string_literal: true

module Owner
  # Responses and fields for owner commands.
  RESPONSE = {
    1 => "This command is owner only.",
    2 => "### Gateway Statistics",
    3 => "Acknowledged request!",
    4 => "Success! No content.",
    5 => "```prolog\n%s\n```",
    6 => "-# %s total events",
    7 => "```ruby\n%s\n```"
  }.freeze

  # Application commands for owner commands.
  COMMANDS = {
    1 => "`/science`"
  }.freeze

  # Mapping of smart quotes to escape.
  QUOTES = %w[‘ ’ “ ”].freeze

  # Escape curly quotes into straight quotes.
  def self.escape(code)
    code if QUOTES.map { code.gsub!(it, '"') }
  end
end
