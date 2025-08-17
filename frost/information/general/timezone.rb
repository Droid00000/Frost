# frozen_string_literal: true

module General
  # Localized time for a timezone.
  def self.time(data)
    if Birthdays.timezone(data).nil?
      data.edit_response(content: RESPONSE[1])
      return
    end

    zone = Birthdays.timezone(data).now.to_time

    format = lambda do |time|
      date = time.strftime(time.day.ordinal)
      time.strftime("%B #{date}, %Y at %I:%M %p")
    end

    data.edit_response(content: format.call(zone))
  end
end
