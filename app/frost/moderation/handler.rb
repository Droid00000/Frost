# frozen_string_literal: true

require_relative "block"
require_relative "delete"
require_relative "nickname"

module ModerationCommands
  extend Discordrb::EventContainer

  application_command(:change).subcommand(:nickname) do |event|
    event.defer(ephemeral: true)
    update_nickname(event)
  end

  application_command(:purge).subcommand(:messages) do |event|
    event.defer(ephemeral: true)
    delete_messages(event)
  end

  application_command(:block) do |event|
    event.defer(ephemeral: false)
    block_member(event)
  end
end
