# frozen_string_literal: true

module General
  # Responses and fields for general commands.
  RESPONSE = {
    1 => "Invalid timezone."
  }.freeze

  # Convert a time object into a formatted string.
  # @param time [Time] The time object to convert.
  # @return [String] The time object in the format.
  def format_time(time)
    date = time.strftime(time.day.ordinal)
    time.strftime("%B #{date}, %Y at %I:%M %p")
  end
end
