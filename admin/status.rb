# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require 'discordrb'

def update_status(data)
  unless safe_name?(data.options['description'])
    data.edit_response(content: RESPONSE[502])
    return
  end

  unless TOML['Discord']['CONTRIBUTORS'].include?(data.user.id)
    data.edit_response(content: RESPONSE[503])
    return
  end

  unless !data.options['description'].nil?
    data.bot.update_status(fetch_status(type: :indicator), data.options['description'], ACTIVITY[70])
  end

  unless !data.options['type'].nil?
    data.bot.update_status(data.options['type'], fetch_status(type: :description), ACTIVITY[70])
  end
end
