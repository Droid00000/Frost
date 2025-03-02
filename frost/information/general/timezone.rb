# frozen_string_literal: true

# Localized time for a timezone.
def general_timezone(data)
  if Birthday.timezone(data).nil?
    data.edit_response(content: RESPONSE[125])
    return
  end

  timezone = Birthday.zone(Birthday.timezone(data))

  builder = lambda do |time|
    time = Time.at(time.to_time)
    date = time.strftime(time.day.ordinal.to_s)
    time.strftime("%B #{date}, %Y at %I:%M %p")
  end

  data.edit_response(content: builder.call(timezone))
end
