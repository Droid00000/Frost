# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/schema'
require 'discordrb'

def setup_pin_archiver(data)
  if archiver_records(server: data.server.id, type: :check)
    data.edit_response(content: "#{RESPONSE[22]} <##{data.options['channel']}>")
    return
  end

  archiver_records(server: data.server.id, channel: data.options['channel'], type: :setup)
  data.edit_response(content: "#{RESPONSE[22]} <##{data.options['channel']}>")
end
