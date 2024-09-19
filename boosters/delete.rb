# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/schema'
require 'discordrb'

def delete_role(data)
  unless booster_records(server: data.server.id, user: data.user.id, type: :check_user)
    data.edit_response(content: RESPONSE[404])
    return
  end

  unless booster_records(server: data.server.id, type: :enabled)
    data.edit_response(content: RESPONSE[301])
    return
  end

  if booster_records(server: data.server.id, user: data.user.id, type: :banned)
    data.edit_response(content: RESPONSE[302])
    return
  end

  #unless data.user.boosting?
  #  data.edit_response(content: RESPONSE[401])
  #  return
  #end

  delete_guild_role(data.server.id, data.user.id)

  booster_records(server: data.server.id, user: data.user.id, type: :delete)

  data.edit_response(content: "#{RESPONSE[205]} #{EMOJI[30]}")
end
