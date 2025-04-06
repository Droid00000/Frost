# frozen_string_literal: true

require_relative "add"
require_relative "edit"
require_relative "remove"
require_relative "disable"

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:event).group(:roles) do |group|
    group.subcommand("disable") do |event|
      event.defer(ephemeral: true)
      Events.disable(event)
    end

    group.subcommand("remove") do |event|
      event.defer(ephemeral: true)
      Events.remove(event)
    end

    group.subcommand("edit") do |event|
      event.defer(ephemeral: true)
      Events.edit(event)
    end

    group.subcommand("add") do |event|
      event.defer(ephemeral: true)
      Event.add(event)
    end
  end
end
