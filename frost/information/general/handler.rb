# frozen_string_literal: true

require_relative "values"
require_relative "process"
require_relative "chapter"
require_relative "settings"
require_relative "timezone"

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:next).group(:chapter) do |group|
    group.subcommand("when") do |event|
      event.defer(ephemeral: false)
      General.chapter(event)
    end
  end

  application_command(:settings) do |event|
    event.defer(ephemeral: true)
    General.info(event)
  end

  application_command(:time) do |event|
    event.defer(ephemeral: false)
    General.time(event)
  end

  server_role_delete do |event|
    General.roles(event)
  end

  channel_delete do |event|
    General.channels(event)
  end
end
