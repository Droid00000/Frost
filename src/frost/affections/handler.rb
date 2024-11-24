# frozen_string_literal: true

import 'hug'
import 'nom'
import 'bonk'
import 'poke'
import 'anger'
import 'punch'
import 'sleep'

module AffectionCommands
  extend Discordrb::EventContainer

  application_command(:hug) do |event|
    event.defer(ephemeral: false)
    hug_member(event)
  end

  application_command(:nom) do |event|
    event.defer(ephemeral: false)
    nom_member(event)
  end

  application_command(:bonk) do |event|
    event.defer(ephemeral: false)
    bonk_member(event)
  end

  application_command(:poke) do |event|
    event.defer(ephemeral: false)
    poke_member(event)
  end

  application_command(:punch) do |event|
    event.defer(ephemeral: false)
    punch_member(event)
  end

  application_command(:sleep) do |event|
    event.defer(ephemeral: false)
    sleep_member(event)
  end

  application_command(:angered) do |event|
    event.defer(ephemeral: false)
    angry_member(event)
  end
end
