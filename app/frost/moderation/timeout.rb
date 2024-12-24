# frozen_string_literal: true

def mute_member(data)
  unless data.server.bot.permission?(:moderate_members)
    data.edit_response(content: RESPONSE[59])
    return
  end

  if data.member('member').hierarchy >= data.server.bot.hierarchy
    data.edit_response(content: RESPONSE[62])
    return
  end

  if data.member('member').hierarchy >= data.user.hierarchy
    data.edit_response(content: RESPONSE[62])
    return
  end

  if data.member('member').permission?(:administrator)
    data.edit_response(content: RESPONSE[62])
    return
  end

  if data.member('member').owner?
    data.edit_response(content: RESPONSE[62])
    return
  end

  begin
    time = Rufus::Scheduler.parse_duration(data.options['duration'])
  rescue ArgumentError
    data.edit_response(content: RESPONSE[60])
    return
  end

  begin
    data.member('member').timeout = Time.now + time
  rescue ArgumentError
    data.edit_response(content: RESPONSE[61])
    return
  end

  data.edit_response(content: format(RESPONSE[63], data.options['member']))
end
