# frozen_string_literal: true

require_relative '../data/constants'
require 'discordrb'

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:help) do |event|
    event.defer(ephemeral: true)
    general_help_embed(event)
  end

  application_command(:about) do |event|
    event.defer(ephemeral: true)
    event.edit_response(content: "#{RESPONSE[500]} #{EMOJI[10]}")
  end

  application_command(:settings) do |event|
    event.defer(ephemeral: true)
    server_settings(event)
  end

  application_command(:update).subcommand(:status) do |event|
    event.defer(ephemeral: true)
    update_status(event)
  end

  application_command(:pin).group(:archiver) do |group|
    group.subcommand('setup') do |event|
      event.defer(ephemeral: true)
      setup_archiver(event)
    end
  end
end
