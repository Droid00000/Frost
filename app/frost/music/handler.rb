# frozen_string_literal: true

require_relative "move"
require_relative "seek"
require_relative "play"
require_relative "skip"
require_relative "queue"
require_relative "pause"
require_relative "volume"
require_relative "search"
require_relative "resume"
require_relative "remove"
require_relative "shuffle"
require_relative "playing"
require_relative "previous"
require_relative "internals"
require_relative "paginator"
require_relative "disconnect"

module MusicCommands
  extend Discordrb::EventContainer

  application_command(:music).subcommand(:disconnect) do |event|
    event.defer(ephemeral: false)
    music_disconnect(event)
  end

  application_command(:music).subcommand(:previous) do |event|
    event.defer(ephemeral: false)
    music_previous(event)
  end

  application_command(:music).subcommand(:shuffle) do |event|
    event.defer(ephemeral: false)
    music_shuffle(event)
  end

  application_command(:music).subcommand(:volume) do |event|
    event.defer(ephemeral: false)
    music_volume(event)
  end

  application_command(:music).subcommand(:resume) do |event|
    event.defer(ephemeral: false)
    music_resume(event)
  end

  application_command(:music).subcommand(:queue) do |event|
    event.defer(ephemeral: true)
    music_queue(event)
  end

  application_command(:music).subcommand(:clear) do |event|
    event.defer(ephemeral: false)
    music_remove(event)
  end

  application_command(:music).subcommand(:pause) do |event|
    event.defer(ephemeral: false)
    music_pause(event)
  end

  application_command(:music).subcommand(:skip) do |event|
    event.defer(ephemeral: false)
    music_skip(event)
  end

  application_command(:music).subcommand(:play) do |event|
    event.defer(ephemeral: false)
    music_play(event)
  end

  application_command(:music).subcommand(:seek) do |event|
    event.defer(ephemeral: false)
    music_seek(event)
  end

  application_command(:music).subcommand(:move) do |event|
    event.defer(ephemeral: false)
    music_move(event)
  end

  application_command(:music).group(:currently) do |group|
    group.subcommand(:playing) do |event|
      event.defer(ephemeral: true)
      music_current(event)
    end
  end

  button(custom_id: REGEX[8]) do |event|
    event.defer_update
    music_pages(event)
  end

  interaction_create(type: 4) do |event|
    music_search(event)
  end

  voice_server_update do |event|
    process_server(event)
  end

  voice_state_update do |event|
    process_state(event)
  end
end
