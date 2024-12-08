# frozen_string_literal: true

import 'pins'
import 'roles'
import 'status'
import 'utilities'

module AdminCommands
  extend Discordrb::EventContainer

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
end
