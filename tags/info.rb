# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/schema'
require 'discordrb'

def tag_info(data)
  unless tag_records(name: data.options['name'], type: :check)
    data.edit_response(content: RESPONSE[])
    return
  end

  message = data.bot.resolve_message(tag_records(name: data.options['name'], type: :get)[0],
                                     tag_records(name: data.options['name'], type: :get)[2])

  data.edit_response do |builder|
    builder.add_embed do |embed|
    end
  end
end
