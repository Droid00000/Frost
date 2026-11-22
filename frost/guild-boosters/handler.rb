# frozen_string_literal: true

module BoosterCommands
  extend Discordrb::EventContainer

  modal_submit(custom_id: "booster_settings") do |event|
    event.defer(ephemeral: true)
    Boosters.configure_submission(event)
  end

  application_command(:booster).group(:admin) do |group|
    group.subcommand(:configure) do |event|
      Boosters.booster_admin_configure(event)
    end

    group.subcommand(:disable) do |event|
      event.defer(ephemeral: true)
      Boosters.booster_admin_disable(event)
    end

    group.subcommand(:delete) do |event|
      event.defer(ephemeral: true)
      Boosters.booster_admin_delete(event)
    end

    group.subcommand(:bans) do |event|
      event.defer(ephemeral: true)
      Boosters.booster_admin_bans(event)
    end

    group.subcommand(:add) do |event|
      event.defer(ephemeral: true)
      Boosters.booster_admin_add(event)
    end
  end

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
