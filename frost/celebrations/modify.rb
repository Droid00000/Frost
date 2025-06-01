# frozen_string_literal: true

module Birthdays
  # setup and add your birthday.
  def self.edit(data)
    # Initialize the invoking user.
    member = Birthdays::Member.new(data)

    if member.blank?
      data.edit_response(content: RESPONSE[1])
      return
    end

    if member.guild.blank?
      data.edit_response(content: RESPONSE[4])
      return
    end

    if data.options.empty?
      data.edit_response(content: RESPONSE[8])
      return
    end

    unless valid_timezone?(data)
      data.edit_response(content: RESPONSE[11])
      return
    end

    unless valid_datetime?(data)
      data.edit_response(content: RESPONSE[12])
      return
    end

    member.edit_birthdate(data.options)

    # Delete the existing local task for the user here.
    Scheduler.delete(data.user.id)

    # Re-schedule the local task for the user here.
    Scheduler.schedule(data.user.id)

    data.edit_response(content: RESPONSE[9])
  end
end
