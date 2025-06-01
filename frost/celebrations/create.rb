# frozen_string_literal: true

module Birthdays
  # setup and add your birthday.
  def self.create(data)
    # Initialize the invoking user.
    member = Birthdays::Member.new(data)

    unless member.blank?
      data.edit_response(content: RESPONSE[6])
      return
    end

    if member.guild.blank?
      data.edit_response(content: RESPONSE[4])
      return
    end

    unless valid_timezone?(data.options)
      data.edit_response(content: RESPONSE[11])
      return
    end

    unless valid_datetime?(data.options)
      data.edit_response(content: RESPONSE[12])
      return
    end

    member.birthday = Birthdays.date(data)

    # Schedule the local task for the user here.
    Scheduler.schedule(data.user.id)

    data.edit_response(content: RESPONSE[6])
  end
end
