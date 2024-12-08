# frozen_string_literal: true

import 'setup'
import 'disable'

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:events).group(:role) do |group|
    group.subcommand('setup') do |event|
      event.defer(ephemeral: true)
      roles_setup(event)
    end

    group.subcommand('disable') do |event|
      event.defer(ephemeral: true)
      roles_disable(event)
    end
  end
end
