# frozen_string_literal: true

require 'discordrb'
require 'data/schema'
require 'data/constants'

def update_status(data)
  unless safe_name?(data.options['description'])
    data.edit_response(content: RESPONSE[11])
    return
  end

  unless TOML['Discord']['CONTRIBUTORS'].include?(data.user.id)
    data.edit_response(content: RESPONSE[12])
    return
  end

  if data.options['description'] || data.options['type']
    data.bot.custom_status(data.options['type'], data.options['description'])
  end

  data.edit_response(content: "#{RESPONSE[13]} #{EMOJI[1]}")
end
