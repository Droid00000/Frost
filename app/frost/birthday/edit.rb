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
      old_birthday = Frost::Birthdays.user(data, :birthday)

      if data.options["date"]
        new_date = DateTime.parse(data.options["date"])
        old_birthday = DateTime.parse(old_birthday.strftime("%Y-#{new_date.month}-#{new_date.day}T%H:%M:%S%:z"))
      end

      if data.options["timezone"]
        zone = data.options["timezone"].split("/").map { |tz| tz.split(" ").map(&:capitalize).join(" ") }.join("/").sub(" ", "_")
        zone = TZInfo::Timezone.get(zone)
        old_birthday = zone.local_time(old_birthday.year, old_birthday.month, old_birthday.day)
      end
    rescue StandardError
      data.edit_response(content: RESPONSE[105])
      return
    end

    payload = { notify: data.options["announcement"], birthday: old_birthday&.to_time&.iso8601 }.compact

    Frost::Birthdays.edit(data, payload)

    if old_birthday.nil? && data.options["announcement"]
      data.edit_response(content: RESPONSE[110])
      return
    end
    
    data.edit_response(content: format(RESPONSE[107], old_birthday&.to_time&.to_i))
  end
end
