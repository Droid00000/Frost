# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative 'unfreeze'
require 'discordrb'

def freeze_server(data)
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

  unless safe_name?(data.options['reason'])
    data.edit_response(content: RESPONSE[49])
    return
  end

  schedule_unfreeze(data.server, data.options['duration']) if data.options['duration']

  data.edit_response(content: process_input(data.options['duration'], data.options['reason'], :lock))
end
