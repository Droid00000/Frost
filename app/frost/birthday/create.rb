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

    #begin
      date = DateTime.parse(data.options["date"])
      zone = TZInfo::Timezone.get(data.options["timezone"].split("/").map { |tz| tz.split(/[\s_]+/).map(&:capitalize).join("_") }.join("/"))
      year = date.month < Time.now.month ? date.year + 1 : date.year
      date = zone.local_time(year, date.month, date.day)
    #rescue StandardError
    #  data.edit_response(content: RESPONSE[105])
    #  return
    #end

    active = (date.month == Time.now.month) && (date.day == Time.now.day) ? true : false

    payload = {
      active: active,
      notify: data.options["announcement"],
      user_id: data.user.id,
      guild_id: data.server.id,
      birthday: date.to_time.iso8601
    }

    Frost::Birthdays.add(**payload)

    data.edit_response(content: format(RESPONSE[107], date.to_time.to_i))
  end
end
