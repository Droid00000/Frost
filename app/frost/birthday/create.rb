# frozen_string_literal: true

module Birthday
  # setup and add your birthday.
  def self.create(data)
    unless Frost::Birthdays::Settings.role(data)
      data.edit_response(content: RESPONSE[104])
      return
    end

    if Frost::Birthdays.user?(data)
      data.edit_response(content: RESPONSE[112])
      return
    end

    begin
      date = Time.parse(data.options["date"])

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

    active = true if (date.month == Time.now.month) && (date.day == Time.now.day)

    payload = {
      active: !!active,
      user_id: data.user.id,
      guild_id: data.server.id,
      birthday: date.iso8601,
      timezone: zone.identifier
    }

    Frost::Birthdays.add(**payload)

    data.edit_response(content: format(RESPONSE[107], Time.parse(data.options["date"]).to_i))
  end
end
