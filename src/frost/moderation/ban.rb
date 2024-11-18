# frozen_string_literal: true

require 'discordrb'
require 'constants'
require 'functions'

def bulk_ban(data)
  unless data.bot.profile.on(data.server).permission?(:ban_members)
    data.edit_response(content: RESPONSE[68])
    return
  end

  unless data.bot.profile.on(data.server).permission?(:manage_server)
    data.edit_response(content: RESPONSE[69])
    return
  end

  unless safe_name?(data.options['reason'])
    data.edit_response(content: RESPONSE[49])
    return
  end

  members = data.options['members'].delete('@<>,').split(',').reject do |member|
    data.bot.member(data.server, member).highest_role.position >= data.user.highest_role.position
  end

  if members.empty?
    data.edit_response(content: RESPONSE[71])
    return
  end

  while members.size > 200
    members.pop
  end

  bans = data.server.bulk_ban(members, data.options['messages'], data.options['reason'])

  data.edit_response(content: "#{RESPONSE[70]} #{bans.count}")
end
