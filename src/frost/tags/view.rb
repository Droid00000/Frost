# frozen_string_literal: true

require 'discordrb'
require 'data/schema'
require 'data/constants'
require 'data/functions'

def tag_info(data)
  unless tag_records(name: data.options['name'], type: :exists?)
    data.edit_response(content: RESPONSE[52])
    return
  end

  message = data.bot.resolve_message(tag_records(name: data.options['name'], type: :get)[0],
                                     tag_records(name: data.options['name'], type: :get)[2])

  data.edit_response(content: message.content || REPONSE[53])
end