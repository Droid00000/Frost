# frozen_string_literal: true

require_relative 'ban'
require_relative 'block'
require_relative 'freeze'
require_relative 'timeout'
require_relative 'unfreeze'
require_relative 'nickname'

module ModerationCommands
  extend Discordrb::EventContainer

  application_command(:change).subcommand(:nickname) do |event|
    event.defer(ephemeral: true)
    update_nickname(event)
  end

  application_command(:bulk).subcommand(:ban) do |event|
    event.defer(ephemeral: false)
    bulk_ban(event)
  end

  application_command(:unfreeze) do |event|
    event.defer(ephemeral: false)
    unfreeze_server(event)
  end

  application_command(:freeze) do |event|
    event.defer(ephemeral: false)
    freeze_server(event)
  end

  application_command(:block) do |event|
    event.defer(ephemeral: false)
    block_member(event)
  end

  application_command(:mute) do |event|
    event.defer(ephemeral: false)
    mute_member(event)
  end
end
