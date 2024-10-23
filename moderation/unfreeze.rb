# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require 'rufus-scheduler'
require 'discordrb'

def unfreeze_server(data)
  data.server.channels.each do |channel|
    channel.define_overwrite(data.server.everyone_role, nil, nil)
  end

  unless safe_name?(data.options['reason'])
    data.edit_response(content: RESPONSE[49])
    return
  end

  data.edit_response(content: process_input(data.options['duration'], data.options['reason'], :unlock))
end

def schedule_unfreeze(server, duration)
  Rufus::Scheduler.new.in duration do
    server.channels.each do |channel|
      channel.define_overwrite(server.everyone_role, nil, nil)
    end
  end
end
