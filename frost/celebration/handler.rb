# frozen_string_literal: true

module BirthdayCommands
  extend Discordrb::EventContainer

  application_command(:birthday).subcommand(:delete) do |event|
    event.defer(ephemeral: true)
    Birthdays.delete(event)
  end

  application_command(:birthday).subcommand(:sync) do |event|
    event.defer(ephemeral: true)
    Birthdays.sync(event)
  end

  application_command(:birthday).subcommand(:add) do |event|
    event.defer(ephemeral: true)
    Birthdays.create(event)
  end

  autocomplete(:timezone) do |event|
    Birthdays.search(event)
  end
end
