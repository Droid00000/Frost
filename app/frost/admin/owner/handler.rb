# frozen_string_literal: true

import 'eval'
import 'status'
import 'restart'
import 'shutdown'

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:update).subcommand(:status) do |event|
    event.defer(ephemeral: true)
    owner_status(event)
  end

  application_command(:shutdown) do |event|
    event.defer(ephemeral: true)
    owner_shutdown(event)
  end

  application_command(:restart) do |event|
    event.defer(ephemeral: true)
    owner_restart(event)
  end

  application_command(:eval) do |event|
    event.defer(ephemeral: true)
    owner_eval(event)
  end
end
