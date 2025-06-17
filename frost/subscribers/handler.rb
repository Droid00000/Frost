# frozen_string_literal: true

module BoosterCommands
  extend Discordrb::EventContainer

  application_command(:booster).group(:role) do |group|
    group.subcommand(:claim) do |event|
      event.defer(ephemeral: true)
      Boosters.create(event)
    end

    group.subcommand(:gradient) do |event|
      event.defer(ephemeral: true)
      Boosters.colors(event)
    end

    group.subcommand(:delete) do |event|
      event.defer(ephemeral: true)
      Boosters.delete(event)
    end

    group.subcommand(:edit) do |event|
      event.defer(ephemeral: true)
      Boosters.edit(event)
    end
  end
end
