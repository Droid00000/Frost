# frozen_string_literal: true

require 'schema'
require 'constants'
require 'discordrb'

# Sets the pin archiver channel or updates it.
def setup_pin_archiver(data)
  if archiver_records(server: data.server.id, type: :check)
    archiver_records(server: data.server.id, channel: data.options['channel'], type: :update)
    data.edit_response(content: "#{RESPONSE[22]} <##{data.options['channel']}>")
    return
  end

  archiver_records(server: data.server.id, channel: data.options['channel'], type: :setup)
  data.edit_response(content: "#{RESPONSE[22]} <##{data.options['channel']}>")
end

# Deletes the pin archiver channel in the database.
def disable_pin_archiver(data)
  unless archiver_records(server: data.server.id, type: :check)
    data.edit_response(content: RESPONSE[36])
    return
  end

  archiver_records(server: data.server.id, type: :disable)
  data.edit_response(content: RESPONSE[37])
end
