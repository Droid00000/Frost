# frozen_string_literal: true

require 'discordrb'

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:help) do |event|
    event.defer(ephemeral: true)
    help_embed(event)
  end

  application_command(:about) do |event|
    event.defer(ephemeral: true)
    about_bot(event)
  end

  application_command(:settings) do |event|
    event.defer(ephemeral: true)
    server_settings(event)
  end

  application_command(:pin).group(:archiver) do |group|
    group.subcommand('setup') do |event|
      event.defer(ephemeral: true)
      setup_archiver(event)
    end
  end
end
