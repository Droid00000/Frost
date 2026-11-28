# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:next).group(:chapter) do |group|
    group.subcommand(:when) do |event|
      PersonalThings.next_chapter_when(event)
    end
  end

  application_command(:time) do |event|
    PersonalThings.time(event)
  end
end
