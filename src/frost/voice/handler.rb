# frozen_string_literal: true

import 'help'
import 'play'
import 'stop'
import 'pause'
import 'resume'
import 'disconnect'

module VoiceCommands
  extend Discordrb::EventContainer

  application_command(:music).subcommand(:disconnect) do |event|
    event.defer(ephemeral: false)
    voice_disconnect(event)
  end

  application_command(:music).subcommand(:resume) do |event|
    event.defer(ephemeral: false)
    voice_resume(event)
  end

  application_command(:music).subcommand(:pause) do |event|
    event.defer(ephemeral: false)
    voice_pause(event)
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
