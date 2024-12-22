# frozen_string_literal: true

def delete_messages(data)
  unless data.server.bot.permission?(:manage_messages)
    data.edit_response(content: RESPONSE[67])
    return
  end

  amount = data.channel.prune(data.options['amount'])

  data.edit_response(content: format(RESPONSE[68], amount))
end
