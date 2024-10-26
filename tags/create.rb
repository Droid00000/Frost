# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/schema'
require 'discordrb'

def create_tag(data)
  unless safe_name?(data.options['name'])
    data.edit_response(content: RESPONSE[7])
    return
  end

  unless tag_records(name: data.options['name'], type: :exists?)
    data.edit_response(content: RESPONSE[50])
    return
  end

  tag_records(name: data.options['name'],
              server: event.server.id,
              message: data.options['message'],
              channel: data.channel.id,
              owner: data.user.id,
              type: :create)

  data.edit_response(content: "#{RESPONSE[51]} **#{data.options['name']}**")
end
