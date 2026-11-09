# frozen_string_literal: true

module BoosterCommands
  extend Discordrb::EventContainer

  application_command(:booster).group(:role) do |group|
    group.subcommand(:gradient) do |event|
      event.defer(ephemeral: false)
      Boosters.booster_role_gradient(event)
    end

    group.subcommand(:claim) do |event|
      event.defer(ephemeral: false)
      Boosters.booster_role_create(event)
    end

    group.subcommand(:delete) do |event|
      event.defer(ephemeral: false)
      Boosters.booster_role_delete(event)
    end

    group.subcommand(:edit) do |event|
      event.defer(ephemeral: false)
      Boosters.booster_role_edit(event)
    end
  end
end
