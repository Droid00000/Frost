# frozen_string_literal: true

require 'discordrb'
require_relative './create'
require_relative './delete'
require_relative './help'
require_relative './edit'

module BoosterPerks
  extend Discordrb::EventContainer

  application_command(:booster).group(:role) do |group|
    group.subcommand('claim') do |event|
      event.defer(ephemeral: false)
      create_role(event)
    end

    group.subcommand('edit') do |event|
      event.defer(ephemeral: false)
      edit_role(event)
    end

    group.subcommand('delete') do |event|
      event.defer(ephemeral: true)
      delete_role(event)
    end

    group.subcommand('help') do |event|
      event.defer(ephemeral: true)
      help_embed(event)
    end
  end
end