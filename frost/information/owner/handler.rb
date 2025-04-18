# frozen_string_literal: true

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

  modal_submit(custom_id: "4") do |event|
    Owner.code(event)
  end

  ready(resumed: false) do |event|
    Owner.logs(event)
  end
end
