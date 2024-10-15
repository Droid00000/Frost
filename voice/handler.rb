# frozen_string_literal: true

require_relative 'disconnect'
require_relative 'stop'
require_relative 'play'
require_relative 'help'

module VoiceCommands
  extend Discordrb::EventContainer

  application_command(:voice).subcommand(:disconnect) do |event|
    event.defer(ephemeral: false)
    voice_disconnect(event)
  end

  application_command(:voice).subcommand(:stop) do |event|
    event.defer(ephemeral: false)
    voice_stop(event)
  end

  application_command(:voice).subcommand(:play) do |event|
    event.defer(ephemeral: false)
    voice_play(event)
  end

  application_command(:voice).subcommand(:help) do |event|
    event.defer(ephemeral: true)
    voice_help(event)
  end
end
