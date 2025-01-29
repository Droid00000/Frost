# frozen_string_literal: true

require_relative "edit"
require_relative "create"
require_relative "delete"

module BirthdayRoles
  extend Discordrb::EventContainer

  application_command(:birthday).subcommand(:delete) do |event|
    event.defer(ephemeral: true)
    Birthday.delete(event)
  end

  application_command(:birthday).subcommand(:edit) do |event|
    event.defer(ephemeral: true)
    Birthday.edit(event)
  end

  application_command(:birthday).subcommand(:set) do |event|
    event.defer(ephemeral: true)
    Birthday.create(event)
  end
end
