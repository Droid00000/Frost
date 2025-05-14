# frozen_string_literal: true

module Owner
  # Responses and fields for owner commands.
  RESPONSE = {
    1 => "This command is owner only.",
    2 => "acknowledged request!",
    3 => "Success! No content.",
    4 => "```ruby\n%s\n```"
  }.freeze

  # Application commands for owner commands.
  COMMANDS = {
    1 => "`/science`"
  }.freeze

  # Mapping of smart quotes to escape.
  QUOTES = %w[‘ ’ “ ”].freeze

  # Escape curly quotes into straight quotes.
  def self.escape(code)
    code if QUOTES.map { |old| code.gsub!(old, '"') }
  end
end
