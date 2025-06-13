# frozen_string_literal: true

module Birthdays
  # setup and add your birthday.
  def self.create(data)
    # Initialize the invoking user.
    member = Birthdays::Member.new(data)

    # Process the datetime given to us here.
    birthdate = create_datetime(data.options)

    unless member.blank?
      data.edit_response(content: RESPONSE[6])
      return
    end

    if member.guild.blank?
      data.edit_response(content: RESPONSE[4])
      return
    end

    if birthdate == :err_timezone_data
      data.edit_response(content: RESPONSE[11])
      return
    end

    if birthdate == :err_datetime_data
      data.edit_response(content: RESPONSE[12])
      return
    end

    member.birthday = birthdate

    Scheduler.schedule(data.user.id)

    data.edit_response(content: RESPONSE[6])
  end
end
