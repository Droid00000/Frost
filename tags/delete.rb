# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/schema'
require 'discordrb'

def delete_tag(data)
  unless tag_records(name: data.options['name'], owner: data.user.id, type: :check)
    data.edit_response(content: RESPONSE[])
    return
  end

  tag_records(name: data.options['name'], owner: data.user.id, type: :delete)

  data.edit_response(content: RESPONSE[])
end
