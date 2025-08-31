# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:next).group(:chapter) do |group|
    group.subcommand(:when) do |event|
      event.defer(ephemeral: false)
      General.chapter(event)
    end
  end

  application_command(:time) do |event|
    event.defer(ephemeral: true)
    General.time(event)
  end
end
