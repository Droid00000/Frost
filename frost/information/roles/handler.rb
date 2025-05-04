# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:event).group(:roles) do |group|
    group.subcommand("disable") do |event|
      event.defer(ephemeral: true)
      Roles.disable(event)
    end

    group.subcommand("remove") do |event|
      event.defer(ephemeral: true)
      Roles.remove(event)
    end

    group.subcommand("edit") do |event|
      event.defer(ephemeral: true)
      Roles.edit(event)
    end

    group.subcommand("add") do |event|
      event.defer(ephemeral: true)
      Roles.add(event)
    end
  end
end
