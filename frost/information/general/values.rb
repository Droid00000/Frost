# frozen_string_literal: true

module General
  # Responses and fields for general commands.
  RESPONSE = {
    1 => "**Next Chapter:** <t:%s:D>",
    2 => "Invalid timezone."
  }.freeze

  # Application commands for general commands.
  COMMANDS = {
    1 => "`/next chapter when`",
    2 => "`/time`"
  }.freeze
end
