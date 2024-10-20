# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/schema'
require 'discordrb'

def tag_info(data)
  unless tag_records(name: data.options['name'], type: :check)
    data.edit_response(content: RESPONSE[])
    return
  end

  message_id = tag_records(name: data.options['name'], type: :get)
  data.bot.resolve_message(message_id[0], message_id[2])    
end
