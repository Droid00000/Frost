# frozen_string_literal: true

require_relative "eval"
require_relative "values"
require_relative "flipper"
require_relative "science"
require_relative "garbage"

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:coin).subcommand(:flip) do |event|
    event.defer(ephemeral: false)
    Owner.flip(event)
  end

  application_command(:science) do |event|
    event.defer(ephemeral: true)
    Owner.science(event)
  end

  modal_submit(user: owner) do |event|
    Owner.experiment(event)
  end
end
