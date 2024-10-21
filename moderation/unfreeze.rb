# frozen_string_literal: true

require_relative '../data/constants'
require 'discordrb'

def unfreeze_server(data)
  data.server.channels.each do |channel|
    channel.define_overwrite(data.server.everyone_role, nil, nil)
  end

  data.edit_response(content: "#{RESPONSE[48]} #{proccess_input(data.options['reason'])}")
end
