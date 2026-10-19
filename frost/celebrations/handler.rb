# frozen_string_literal: true

module BirthdayCommands
  extend Discordrb::EventContainer

  application_command(:birthday).subcommand(:delete) do |event|
    event.defer(ephemeral: true)
    Birthdays.birthday_delete(event)
  end

  application_command(:birthday).subcommand(:sync) do |event|
    event.defer(ephemeral: true)
    Birthdays.birthday_sync(event)
  end

  application_command(:birthday).subcommand(:add) do |event|
    event.defer(ephemeral: true)
    Birthdays.birthday_add(event)
  end

  application_command(:time) do |event|
    event.defer(ephemeral: true)
    Birthdays.generic_time(event)
  end

  autocomplete(:timezone) do |event|
    Birthdays.search_timezone(event)
  end
end
