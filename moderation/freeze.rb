# frozen_string_literal: true

require 'discordrb'
require 'rufus-scheduler'
require 'data/constants'
require 'data/functions'

def freeze_server(data)
  unless safe_name?(data.options['reason'])
    data.edit_response(content: RESPONSE[49])
    return
  end

  unless data.bot.profile.on(data.server).permission?(:manage_channels)
    data.edit_response(content: RESPONSE[62])
    return
  end

  data.server.channels.each do |channel|
    case channel.type
    when 0
      channel.define_overwrite(data.server.everyone_role, nil, 2048)
    when 2
      channel.define_overwrite(data.server.everyone_role, nil, 3147776)
    when 15
      channel.define_overwrite(data.server.everyone_role, nil, 377957124096)
    end
  end

  schedule_unfreeze(data.server, data.options['duration']) if data.options['duration']

  data.edit_response(content: process_input(data.options['duration'], data.options['reason'], :lock))
end

def schedule_unfreeze(server, duration)
  Rufus::Scheduler.new.in duration do
    server.channels.each do |channel|
      channel.define_overwrite(server.everyone_role, nil, nil)
    end
  end
end
