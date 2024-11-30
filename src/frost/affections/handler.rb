# frozen_string_literal: true

module AffectionCommands
  extend Discordrb::EventContainer

  application_command(:hug) do |event|
    hug_member(event)
  end

  application_command(:nom) do |event|
    nom_member(event)
  end

  application_command(:bonk) do |event|
    bonk_member(event)
  end

  application_command(:poke) do |event|
    poke_member(event)
  end

  application_command(:punch) do |event|
    punch_member(event)
  end

  application_command(:sleep) do |event|
    sleep_member(event)
  end

  application_command(:angered) do |event|
    angry_member(event)
  end
end
