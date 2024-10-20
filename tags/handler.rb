# frozen_string_literal: true

require_relative 'create'
require_relative 'delete'
require_relative 'view'
require_relative 'info'

module TagCommands
  extend Discordrb::EventContainer

  application_command(:create).subcommand(:tag) do |event|
    event.defer(ephemeral: true)
    create_tag(event)
  end

  application_command(:delete).subcommand(:tag) do |event|
    event.defer(ephemeral: false)
    delete_tag(event)
  end

  application_command(:view).subcommand(:tag) do |event|
    event.defer(ephemeral: true)
    view_tag(event)
  end

  application_command(:tag).subcommand(:info) do |event|
    event.defer(ephemeral: true)
    info_tag(event)
  end
end
