# frozen_string_literal: true

module AffectionCommands
  extend Discordrb::EventContainer

  application_command(:hug) do |event|
    Affections.call(event)
  end

  application_command(:nom) do |event|
    Affections.call(event)
  end

  application_command(:bonk) do |event|
    Affections.call(event)
  end

  application_command(:poke) do |event|
    Affections.call(event)
  end

  application_command(:punch) do |event|
    Affections.call(event)
  end

  application_command(:angered) do |event|
    Affections.call(event)
  end
end
