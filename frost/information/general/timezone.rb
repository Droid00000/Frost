# frozen_string_literal: true

module General
  # Localized time for a timezone.
  def self.time(data)
    if Birthdays.timezone(data).nil?
      data.edit_response(content: RESPONSE[1])
      return
    end

    zone = Birthdays.timezone(data).now.to_time

    data.edit_response(content: format_time(zone))
  end
end
