# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/schema'
require 'discordrb'

def delete_role(data)
  if booster_records(server: data.server.id, user: data.user.id, type: :banned)
    data.edit_response(content: RESPONSE[6])
    return
  end

  unless booster_records(server: data.server.id, user: data.user.id, type: :check_user)
    data.edit_response(content: RESPONSE[9])
    return
  end

  unless booster_records(server: data.server.id, type: :enabled)
    data.edit_response(content: RESPONSE[5])
    return
  end

  unless data.user.boosting?
    data.edit_response(content: RESPONSE[8])
    return
  end

  data.server.delete_role(booster_records(server: server_id, user: user_id, type: :get_role), REASON[3])

  booster_records(server: data.server.id, user: data.user.id, type: :delete)

  data.edit_response(content: "#{RESPONSE[3]} #{EMOJI[3]}")
end
