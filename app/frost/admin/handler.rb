# frozen_string_literal: true

import 'help'
import 'pins'
import 'roles'
import 'status'
import 'boosters'
import 'settings'
import 'utilities'

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:help) do |event|
    event.defer(ephemeral: true)
    general_help_embed(event)
  end

  application_command(:about) do |event|
    event.defer(ephemeral: true)
    event.edit_response(content: "#{RESPONSE[10]} #{EMOJI[1]}")
  end

  application_command(:settings) do |event|
    event.defer(ephemeral: true)
    server_settings(event)
  end

  application_command(:shutdown) do |event|
    event.defer(ephemeral: true)
    shutdown_command(event)
  end

  application_command(:restart) do |event|
    event.defer(ephemeral: true)
    restart_command(event)
  end

  application_command(:eval) do |event|
    event.defer(ephemeral: true)
    eval_command(event)
  end

  application_command(:update).subcommand(:status) do |event|
    event.defer(ephemeral: true)
    update_status(event)
  end

  application_command(:pin).group(:archiver) do |group|
    group.subcommand('setup') do |event|
      event.defer(ephemeral: true)
      setup_pin_archiver(event)
    end

    group.subcommand('disable') do |event|
      event.defer(ephemeral: true)
      disable_pin_archiver(event)
    end
  end

  application_command(:events).group(:role) do |group|
    group.subcommand('setup') do |event|
      event.defer(ephemeral: true)
      setup_event_roles(event)
    end

    group.subcommand('disable') do |event|
      event.defer(ephemeral: true)
      disable_event_roles(event)
    end
  end

  application_command(:next).group(:chapter) do |group|
    group.subcommand('when') do |event|
      event.defer(ephemeral: false)
      next_chapter_date(event)
    end
  end

  application_command(:booster).group(:admin) do |group|
    group.subcommand('add') do |event|
      event.defer(ephemeral: true)
      admin_add_booster(event)
    end

    group.subcommand('delete') do |event|
      event.defer(ephemeral: true)
      admin_remove_user(event)
    end

    group.subcommand('ban') do |event|
      event.defer(ephemeral: true)
      admin_blacklist_user(event)
    end

    group.subcommand('unban') do |event|
      event.defer(ephemeral: true)
      admin_remove_blacklist(event)
    end

    group.subcommand('setup') do |event|
      event.defer(ephemeral: true)
      admin_setup_perks(event)
    end

    group.subcommand('disable') do |event|
      event.defer(ephemeral: true)
      admin_disable_perks(event)
    end

    group.subcommand('help') do |event|
      event.defer(ephemeral: true)
      booster_admin_help(event)
    end
  end
end