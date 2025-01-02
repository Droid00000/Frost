# frozen_string_literal: true

require_relative "members"
require_relative "paginator"

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:house).group(:members) do |event|
    event.defer(ephemeral: false)
    members_house(event)
  end

  button(custom_id: "admin") do |event|
    event.defer_update
    admin_member(event)
  end
end
