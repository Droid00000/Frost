# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:science) do |event|
    Owner.science(event)
  end

  modal_submit(custom_id: /3/) do |event|
    Owner.code(event)
  end

  ready(resumed: false) do |event|
    Owner.logs(event)
  end

  raw(filter: false) do |event|
    Owner.raw(event)
  end
end
