# frozen_string_literal: true

import 'help'
import 'chapter'
import 'settings'

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

  application_command(:help) do |event|
    event.defer(ephemeral: true)
    general_help(event)
  end
end
