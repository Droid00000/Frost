# frozen_string_literal: true

module SnowballFights
  extend Discordrb::EventContainer

  application_command(:collect).subcommand(:snowball) do |event|
    event.defer(ephemeral: true)
    collect_snowball(event)
  end

  application_command(:steal).subcommand(:snowball) do |event|
    event.defer(ephemeral: true)
    steal_snowball(event)
  end

  application_command(:throw).subcommand(:snowball) do |event|
    throw_snowball(event)
  end
end
