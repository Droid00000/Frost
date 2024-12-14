# frozen_string_literal: true

import 'stop'
import 'play'
import 'help'
import 'leave'

module MusicCommands
  extend Discordrb::EventContainer

  application_command(:music).subcommand(:leave) do |event|
    event.defer(ephemeral: false)
    music_leave(event)
  end

  application_command(:music).subcommand(:pause) do |event|
    event.defer(ephemeral: false)
    music_stop(event)
  end

  application_command(:music).subcommand(:play) do |event|
    event.defer(ephemeral: false)
    music_play(event)
  end

  application_command(:music).subcommand(:help) do |event|
    event.defer(ephemeral: true)
    music_help(event)
  end

  application_command(:music).subcommand(:next) do |event|
    event.defer(ephemeral: false)
    music_next(event)
  end
end
