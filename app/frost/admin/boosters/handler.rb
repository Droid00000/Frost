# frozen_string_literal: true

require_relative 'add'
require_relative 'ban'
require_relative 'help'
require_relative 'setup'
require_relative 'unban'
require_relative 'delete'
require_relative 'disable'

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:booster).group(:admin) do |group|
    group.subcommand('add') do |event|
      event.defer(ephemeral: true)
      add_booster(event)
    end

    group.subcommand('disable') do |event|
      event.defer(ephemeral: true)
      disable_booster(event)
    end

    group.subcommand('delete') do |event|
      event.defer(ephemeral: true)
      delete_booster(event)
    end

    group.subcommand('unban') do |event|
      event.defer(ephemeral: true)
      unban_booster(event)
    end

    group.subcommand('setup') do |event|
      event.defer(ephemeral: true)
      setup_booster(event)
    end

    group.subcommand('help') do |event|
      event.defer(ephemeral: true)
      help_booster(event)
    end

    group.subcommand('ban') do |event|
      event.defer(ephemeral: true)
      ban_booster(event)
    end
  end
end
