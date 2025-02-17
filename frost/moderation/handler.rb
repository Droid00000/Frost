# frozen_string_literal: true

require_relative "block"
require_relative "delete"
require_relative "nickname"
require_relative "invitation"

module ModerationCommands
  extend Discordrb::EventContainer

  application_command(:gatekeeper).subcommand(:disable) do |event|
    event.defer(ephemeral: true)
    Moderation.resume(event)
  end

  application_command(:gatekeeper).subcommand(:enable) do |event|
    event.defer(ephemeral: true)
    Moderation.pause(event)
  end

  application_command(:change).subcommand(:nickname) do |event|
    event.defer(ephemeral: true)
    Moderation.nickname(event)
  end

  application_command(:purge).subcommand(:messages) do |event|
    event.defer(ephemeral: true)
    Moderation.purge(event)
  end

  application_command(:block) do |event|
    event.defer(ephemeral: false)
    Moderation.block(event)
  end
end
