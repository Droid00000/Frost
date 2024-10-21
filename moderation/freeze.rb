# frozen_string_literal: true

require_relative '../data/constants'
require 'discordrb'

def freeze_server(data)
  data.server.channels.each do |channel|
    case channel.type
    when 0
      channel.define_overwrite(data.server.everyone_role, nil, 2048)
    when 2
      channel.define_overwrite(data.server.everyone_role, nil, 3_147_776)
    when 15
      channel.define_overwrite(data.server.everyone_role, nil, 377_957_124_096)
    end
  end

  unfreeze_server(data.server, data.options['duration']) if data.options['duration']

  data.edit_response(content: "#{RESPONSE[47]} #{proccess_input(data.options['reason'], data.options['reason'])}")
end
