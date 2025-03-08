# frozen_string_literal: true

require_relative "edit"
require_relative "create"
require_relative "delete"
require_relative "builder"
require_relative "syncing"

module BirthdayCommands
  extend Discordrb::EventContainer

  application_command(:birthday).subcommand(:delete) do |event|
    event.defer(ephemeral: true)
    Birthday.delete(event)
  end

  application_command(:birthday).subcommand(:sync) do |event|
    event.defer(ephemeral: true)
    Birthday.sync(event)
  end

  application_command(:birthday).subcommand(:edit) do |event|
    event.defer(ephemeral: true)
    Birthday.edit(event)
  end

  application_command(:birthday).subcommand(:add) do |event|
    event.defer(ephemeral: true)
    Birthday.create(event)
  end

  interaction_create(type: 4) do |event|
    Birthday.search(event)
  end
end
