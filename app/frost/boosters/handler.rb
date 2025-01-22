# frozen_string_literal: true

require_relative "edit"
require_relative "audit"
require_relative "create"
require_relative "delete"

module BoosterPerks
  extend Discordrb::EventContainer

  application_command(:booster).group(:role) do |group|
    group.subcommand(:claim) do |event|
      event.defer(ephemeral: false)
      Boosters.create(event)
    end

    group.subcommand(:delete) do |event|
      event.defer(ephemeral: true)
      Boosters.delete(event)
    end

    group.subcommand(:edit) do |event|
      event.defer(ephemeral: false)
      Boosters.edit(event)
    end
  end
end
