# frozen_string_literal: true

require_relative "back"
require_relative "members"
require_relative "forward"

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:house).subcommand(:members) do |event|
    event.defer(ephemeral: false)
    members_house(event)
  end

  button { |event| event.defer_update; members_forward(event) }
end
