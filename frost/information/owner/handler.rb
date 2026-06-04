# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:science) do |event|
    Owner.science(event)
  end

  modal_submit(custom_id: "AD") do |event|
    Owner.code(event)
  end

  ready do |event|
    Owner.logs(event)
  end

  raw do |event|
    Owner.raw(event)
  end
end
