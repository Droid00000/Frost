# frozen_string_literal: true

module AffectionCommands
  extend Discordrb::EventContainer

  application_command(:hug) do |event|
    Affections.hug(event)
  end

  application_command(:nom) do |event|
    Affections.nom(event)
  end

  application_command(:bonk) do |event|
    Affections.bonk(event)
  end

  application_command(:poke) do |event|
    Affections.poke(event)
  end

  application_command(:punch) do |event|
    Affections.punch(event)
  end

  application_command(:sleep) do |event|
    Affections.bedtime(event)
  end

  application_command(:angered) do |event|
    Affections.anger(event)
  end
end
