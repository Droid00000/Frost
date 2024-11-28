# frozen_string_literal: true

def freeze_server(data)
  unless data.server.bot.permission?(:manage_channels)
    data.edit_response(content: RESPONSE[49])
    return
  end

  data.server.channels.each do |channel|
    case channel.type
    when 0
      channel.produce_overwrite(data.server.everyone_role, deny: 2048, reason: REASON[9])
    when 2
      channel.produce_overwrite(data.server.everyone_role, deny: 3147776, reason: REASON[9])
    when 15
      channel.produce_overwrite(data.server.everyone_role, deny: 377957124096, reason: REASON[9])
    end
  end

  schedule_unfreeze(data.server, data.options['duration']) if data.options['duration']

  duration = data.options['duration'] ? "for #{data.options['duration']}" : 'indefinitely'

  data.edit_response(content: format(RESPONSE[40], data.server.name, duration))
end

def schedule_unfreeze(server, duration)
  Rufus::Scheduler.new.in duration do
    server.channels.each do |channel|
      case channel.type
      when 0
        channel.destroy_overwrite(server.everyone_role, allow: 2048, reason: REASON[11])
      when 2
        channel.destroy_overwrite(server.everyone_role, allow: 3147776, reason: REASON[11])
      when 15
        channel.destroy_overwrite(server.everyone_role, allow: 377957124096, reason: REASON[11])
      end
    end
  end
end
