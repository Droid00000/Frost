# frozen_string_literal: true

import 'help'
import 'edit'
import 'audit'
import 'create'
import 'delete'

module BoosterPerks
  extend Discordrb::EventContainer
  server_role_delete { |event| role_delete_event(event) }

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
