# frozen_string_literal: true

def update_nickname(data)
  unless data.server.bot.permission?(:manage_nicknames)
    data.edit_response(content: RESPONSE[66])
    return
  end

  if data.server.bot.id == data.options['member']
    data.edit_response(content: RESPONSE[58])
    return
  end

  if data.member('member').hierarchy >= data.user.hierarchy
    data.edit_response(content: RESPONSE[58])
    return
  end

  if data.member('member').hierarchy >= data.server.bot.hierarchy
    data.edit_response(content: RESPONSE[69])
    return
  end

  data.member('member').nick = data.options['nickname']

  data.edit_response(content: format(RESPONSE[65], data.options['member']))
end
