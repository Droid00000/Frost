# frozen_string_literal: true

module Birthday
  # setup and add your birthday.
  def self.create(data)
    unless Frost::Birthdays::Settings.role(data)
      data.edit_response(content: RESPONSE[1])
      return
    end

    begin
      date = Time.parse(data.options["date"])
      zone = TZInfo::Timezone.get(data.options["timezone"].split("/").map!(&:capitalize).join("/"))
      date = zone.local_time(date.year, date.month, date.day)
    rescue StandardError
      data.edit_response(content: RESPONSE[1])
      return
    end

    active = (date.month == Time.now.month) && (date.day == Time.now.day) ? true : false

    payload = {
      active: active,
      notify: data.options["announcement"],
      user_id: data.user.id,
      guild_id: data.server.id,
      birthday: date.iso8601
    }

    Frost::Birthdays.add(**payload)

    data.edit_response(content: format(RESPONSE[1]))
  end
end
