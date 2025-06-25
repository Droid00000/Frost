# frozen_string_literal: true

module Owner
  # Responses and fields for owner commands.
  RESPONSE = {
    1 => "-# %s total events since <t:%s:D>",
    2 => "This command is owner only.",
    3 => "### Gateway Statistics",
    4 => "Acknowledged request!",
    5 => "Success! No content.",
    6 => "```prolog\n%s\n```",
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
