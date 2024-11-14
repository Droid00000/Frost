# frozen_string_literal: true

require 'discordrb'
require 'data/schema'
require 'data/constants'

# Turns the bot off and kills the Gateway connection.
def shutdown_command(data)
  if data.user.id == CONFIG['Discord']['OWNER']&.to_i
    data.edit_response(content: RESPONSE[19])
    data.bot.stop
  else
    data.edit_response(content: RESPONSE[18])
  end
end

# Restarts the Gateway connection.
def restart_command(data)
  if data.user.id == CONFIG['Discord']['OWNER']&.to_i
    data.edit_response(content: RESPONSE[67])
    exec('bundle exec ruby --yjit core.rb')
  else
    data.edit_response(content: RESPONSE[18])
  end
end

# Allows us to execute arbitrary code on the current proccess.
def eval_command(data)
  if data.user.id == CONFIG['Discord']['OWNER']&.to_i
    begin
      result = eval data.options['code']
      data.edit_response(content: "**Success:** ```#{data.options['code']}``` **Result:** ```#{result}```")
    rescue StandardError, SyntaxError => e
      data.edit_response(content: "**Error:** ```#{e.message}```")
    end
  else
    data.edit_response(content: RESPONSE[18])
  end
end
