# frozen_string_literal: true

require_relative "play"
require_relative "next"
require_relative "queue"
require_relative "pause"
require_relative "volume"
require_relative "resume"
require_relative "remove"
require_relative "shuffle"
require_relative "internals"
require_relative "disconnect"

module MusicCommands
  extend Discordrb::EventContainer

  application_command(:music).subcommand(:disconnect) do |event|
    event.defer(ephemeral: false)
    music_disconnect(event)
  end

  application_command(:music).subcommand(:volume) do |event|
    event.defer(ephemeral: false)
    music_volume(event)
  end

  application_command(:music).subcommand(:resume) do |event|
    event.defer(ephemeral: false)
    music_resume(event)
  end

  application_command(:music).subcommand(:pause) do |event|
    event.defer(ephemeral: false)
    music_pause(event)
  end

  application_command(:music).subcommand(:next) do |event|
    event.defer(ephemeral: false)
    music_next(event)
  end

  application_command(:music).subcommand(:play) do |event|
    event.defer(ephemeral: false)
    music_play(event)
  end

  voice_server_update do |event|
    process_server(event)
  end

  voice_state_update do |event|
    process_state(event)
  end
end