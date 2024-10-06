# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/schema'
require 'discordrb'

def steal_snowball(data)
  unless snowball_records(user: data.options['member'], type: :check_snowball)
    data.edit_response(content: RESPONSE[16])
    return
  end

  if snowball_records(user: data.options['member'], type: :get_snowball) < data.options['amount']
    data.edit_response(content: RESPONSE[21])
    return
  end

  unless snowball_records(user: data.user.id, type: :check_user)
    snowball_records(user: data.user.id, type: :add_user)
  end

  unless TOML['Discord']['CONTRIBUTORS'].include?(data.user.id)
    data.edit_response(content: RESPONSE[12])
    return
  end

  snowball_records(user: data.user.id, type: :add_snowball, balance: data.options['amount'])

  snowball_records(user: data.options['member'], type: :remove_snowball, balance: data.options['amount'])

  data.edit_response(content: "Successfully stole #{data.options['amount']} snowball(s)!")
end
