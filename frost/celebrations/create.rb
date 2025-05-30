# frozen_string_literal: true

module Birthdays
  # setup and add your birthday.
  def self.create(data)
    # Initialize the invoking user.
    member = Birthdays::Member.new(data)

    unless member.blank?
      data.edit_response(content: RESPONSE[8])
      return
    end

    if member.guild.blank?
      data.edit_response(content: RESPONSE[2])
      return
    end

    unless valid_timezone?(data.options)
      data.edit_response(content: RESPONSE[7])
      return
    end

    unless valid_datetime?(data.options)
      data.edit_response(content: RESPONSE[9])
      return
    end

    member.birthday = Birthdays.date(data)

    data.edit_response(content: RESPONSE[6])
  end
end
