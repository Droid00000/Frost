# frozen_string_literal: true

module CelebrationCommands
  extend Discordrb::EventContainer

  application_command(:birthday).subcommand(:delete) do |event|
    event.defer(ephemeral: true)
    Celebrations.birthday_delete(event)
  end

  application_command(:birthday).subcommand(:sync) do |event|
    event.defer(ephemeral: true)
    Celebrations.birthday_sync(event)
  end

  application_command(:birthday).subcommand(:add) do |event|
    event.defer(ephemeral: true)
    Celebrations.birthday_add(event)
  end

  application_command(:time) do |event|
    event.defer(ephemeral: true)
    Celebrations.generic_time(event)
  end

  autocomplete(:timezone) do |event|
    Celebrations.search_timezone(event)
  end
end
