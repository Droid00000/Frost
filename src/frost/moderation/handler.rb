# frozen_string_literal: true

require_relative 'unfreeze'
require_relative 'freeze'

module ModerationCommands
  extend Discordrb::EventContainer

  application_command(:freeze) do |event|
    event.defer(ephemeral: false)
    freeze_server(event)
  end

  application_command(:unfreeze) do |event|
    event.defer(ephemeral: false)
    unfreeze_server(event)
  end
end
