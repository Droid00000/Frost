# frozen_string_literal: true

require 'schema'
require 'discordrb'
require 'constants'

# Adds a new role to the event roles database.
def setup_event_roles(data)
  if event_records(server: data.server.id, role: data.options['role'], type: :check_role)
    data.edit_response(content: RESPONSE[23])
    return
  end

  event_records(server: data.server.id, role: data.options['role'], type: :register_role)
  data.edit_response(content: "#{RESPONSE[24]} <@&#{data.options['role']}>")
end

# Disabled the event perks functionality for this server.
def disable_event_roles(data)
  unless event_records(server: data.server.id, type: :enabled)
    data.edit_response(content: RESPONSE[38])
    return
  end

  event_records(server: data.server.id, type: :disable)
  data.edit_response(content: RESPONSE[39])
end
