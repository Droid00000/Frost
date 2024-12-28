# frozen_string_literal: true

require_relative "hug"
require_relative "nom"
require_relative "bonk"
require_relative "poke"
require_relative "punch"
require_relative "sleep"
require_relative "anger"

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
