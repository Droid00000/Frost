# frozen_string_literal: true

module Birthday
  # setup and add your birthday.
  def self.edit(data)
    unless Frost::Birthdays::Settings.role(data)
      data.edit_response(content: RESPONSE[1])
      return
    end

    unless Frost::Birthdays.user?(data)
      data.edit_response(content: RESPONSE[1])
      return
    end

    begin
      old_birthday = Frost::Birthdays.user(data, :birthday)

      if data.options["date"]
        new_date = Time.parse(data.options["date"])
        old_birthday = Time.parse(old_birthday.strftime("%Y-#{new_date.month}-#{new_date.day}T%H:%M:%S%:z"))
      end

      if data.options["timezone"]
        zone = TZInfo::Timezone.get(data.options["timezone"].split("/").map!(&:capitalize).join("/"))
        old_birthday = zone.local_time(old_birthday.year, old_birthday.month, old_birthday.day)
      end
    rescue StandardError
      data.edit_response(content: RESPONSE[1])
      return
    end

    payload = { notify: data.options["announcement"], birthday: old_birthday&.iso8601 }.compact

    Frost::Birthdays.edit(data, payload)

    data.edit_response(content: format(RESPONSE[1]))
  end
end
