# frozen_string_literal: true

require 'discordrb'
require_relative './edit'

module EventRoles
  extend Discordrb::EventContainer

  application_command(:event).group(:role) do |group|
    group.subcommand('edit') do |event|
      event.defer(ephemeral: false)
      edit_event_role(event)
    end
  end
end