# frozen_string_literal: true

module Birthdays
  # setup and add your birthday.
  def self.create(data)
    # Initialize the invoking user.
    member = Birthdays::Member.new(data)

    # Process the datetime given to us here.
    birthdate = create_datetime(data.options)

    if member.guild.blank?
      data.edit_response(content: RESPONSE[4])
      return
    end

    if birthdate == :err_timezone_data
      data.edit_response(content: RESPONSE[8])
      return
    end

    if birthdate == :err_datetime_data
      data.edit_response(content: RESPONSE[9])
      return
    end

    member.birthday = birthdate

    # Create the new job with the new data.
    Orchestrator.schedule(data.user)

    if member.blank?
      data.edit_response(content: RESPONSE[7])
    else
      data.edit_response(content: RESPONSE[6])
    end
  end
end
