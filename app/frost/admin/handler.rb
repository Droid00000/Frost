# frozen_string_literal: true

import 'help'
import 'pins'
import 'roles'
import 'status'
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
end
