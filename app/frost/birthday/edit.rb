# frozen_string_literal: true

module Birthday
  # setup and add your birthday.
  def self.edit(data)
    unless Frost::Birthdays::Settings.role(data)
      data.edit_response(content: RESPONSE[104])
      return
    end

    if data.options.empty?
      data.edit_response(content: RESPONSE[113])
      return
    end

    unless Frost::Birthdays.user?(data)
      data.edit_response(content: RESPONSE[103])
      return
    end

    begin
      date = Time.parse(data.options["date"]) if data.options["date"]

      if data.options["timezone"]
        raw_timezone = data.options["timezone"]

        split = data.options["timezone"].split("/").map do |part|
          part.split(/[\s_]+/).map(&:capitalize).join("_")
        end

        zone = TZInfo::Timezone.get(split.join("/"))
      end

    rescue StandardError
      data.edit_response(content: RESPONSE[105])
      return
    end

    payload = { birthday: date&.iso8601, timezone: zone&.identifier }.compact

    Frost::Birthdays.edit(data, payload)

    data.edit_response(content: format(RESPONSE[107], date&.to_time&.to_i))
  end
end
