# frozen_string_literal: true

require 'discordrb'
require 'data/schema'
require 'data/constants'
require 'data/functions'

def delete_tag(data)
  unless tag_records(name: data.options['name'], owner: data.user.id, type: :check)
    data.edit_response(content: RESPONSE[52])
    return
  end

  tag_records(name: data.options['name'], owner: data.user.id, type: :delete)

  data.edit_response(content: RESPONSE[54])
end
