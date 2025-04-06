# frozen_string_literal: true

require_relative "modify"
require_relative "create"
require_relative "delete"
require_relative "builder"
require_relative "granter"
require_relative "syncing"

module BirthdayCommands
  extend Discordrb::EventContainer

  application_command(:birthday).subcommand(:delete) do |event|
    event.defer(ephemeral: true)
    Birthdays.delete(event)
  end

  application_command(:birthday).subcommand(:grant) do |event|
    event.defer(ephemeral: true)
    Birthdays.grant(event)
  end

  application_command(:birthday).subcommand(:sync) do |event|
    event.defer(ephemeral: true)
    Birthdays.sync(event)
  end

  application_command(:birthday).subcommand(:edit) do |event|
    event.defer(ephemeral: true)
    Birthdays.edit(event)
  end

  application_command(:birthday).subcommand(:add) do |event|
    event.defer(ephemeral: true)
    Birthdays.create(event)
  end

  autocomplete(:timezone) do |event|
    Birthdays.search(event)
  end
end
