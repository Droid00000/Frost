# frozen_string_literal: true

require_relative "edit"
require_relative "setup"
require_relative "remove"
require_relative "disable"

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:event).group(:roles) do |group|
    group.subcommand("setup") do |event|
      event.defer(ephemeral: true)
      roles_setup(event)
    end

    group.subcommand("disable") do |event|
      event.defer(ephemeral: true)
      roles_disable(event)
    end

    group.subcommand("remove") do |event|
      event.defer(ephemeral: true)
      roles_remove(event)
    end

    group.subcommand("edit") do |event|
      event.defer(ephemeral: true)
      roles_edit(event)
    end
  end
end
