# frozen_string_literal: true

require_relative 'chapter'
require_relative 'settings'

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:next).group(:chapter) do |group|
    group.subcommand('when') do |event|
      event.defer(ephemeral: false)
      general_chapter(event)
    end
  end

  application_command(:settings) do |event|
    event.defer(ephemeral: true)
    general_settings(event)
  end
end
