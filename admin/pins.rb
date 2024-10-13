# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require 'discordrb'

def setup_pin_archiver(data)
  if archiver_records(server: data.server.id, type: :check)
    archiver_records(server: data.server.id, channel: data.options['channel'], type: :update)
    data.edit_response(content: "#{RESPONSE[22]} <##{data.options['channel']}>")
    return
  end

  archiver_records(server: data.server.id, channel: data.options['channel'], type: :setup)
  data.edit_response(content: "#{RESPONSE[22]} <##{data.options['channel']}>")
end
