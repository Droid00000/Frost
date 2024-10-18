# frozen_string_literal: true

require_relative 'disconnect'
require_relative 'stop'
require_relative 'play'
require_relative 'help'

module VoiceCommands
  extend Discordrb::EventContainer

  application_command(:music).subcommand(:disconnect) do |event|
    event.defer(ephemeral: false)
    voice_disconnect(event)
  end

  application_command(:music).subcommand(:stop) do |event|
    event.defer(ephemeral: false)
    voice_stop(event)
  end

  application_command(:music).subcommand(:play) do |event|
    event.defer(ephemeral: false)
    voice_play(event)
  end

  application_command(:music).subcommand(:help) do |event|
    event.defer(ephemeral: true)
    voice_help_embed(event)
  end
end
