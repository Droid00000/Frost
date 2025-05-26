# frozen_string_literal: true

module General
  # Localized time for a timezone.
  def self.time(data)
    if Birthdays.timezone(data).nil?
      data.edit_response(content: RESPONSE[2])
      return
    end

    zone = Birthdays.zone(Birthdays.timezone(data))

    builder = lambda do |time|
      time = Time.at(time.to_time)
      date = time.strftime(time.day.ordinal)
      time.strftime("%B #{date}, %Y at %I:%M %p")
    end

    data.edit_response(content: builder.call(zone))
  end
end
