# frozen_string_literal: true

require_relative "send"
require_relative "steal"
require_relative "collect"

module SnowballFights
  extend Discordrb::EventContainer

  application_command(:collect).subcommand(:snowball) do |event|
    event.defer(ephemeral: true)
    Snowballs.collect(event)
  end

  application_command(:steal).subcommand(:snowball) do |event|
    event.defer(ephemeral: true)
    Snowballs.steal(event)
  end

  application_command(:throw).subcommand(:snowball) do |event|
    Snowballs.send(event)
  end
end
