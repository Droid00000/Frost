# frozen_string_literal: true

# Turns the bot off and kills the Gateway connection.
def owner_shutdown(data)
  if data.user.id == CONFIG['Discord']['OWNER']&.to_i
    data.edit_response(content: RESPONSE[19])
    data.bot.stop
  else
    data.edit_response(content: RESPONSE[18])
  end
end
