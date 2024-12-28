# frozen_string_literal: true

require_relative "play"
require_relative "pause"
require_relative "resume"

module MusicCommands
  extend Discordrb::EventContainer

  application_command(:music).subcommand(:disconnect) do |event|
    event.defer(ephemeral: false)
    music_leave(event)
  end

  application_command(:music).subcommand(:play) do |event|
    event.defer(ephemeral: false)
    music_play(event)
  end

  button(custom_id: "Resume") do |event|
    event.defer_update
    music_resume(event)
  end

  button(custom_id: "Pause") do |event|
    event.defer_update
    music_pause(event)
  end

  button(custom_id: "Next") do |event|
    event.defer_update
    music_next(event)
  end

  voice_server_update do |event|
    process_server(event)
  end

  voice_state_update do |event|
    process_state(event)
  end
end
