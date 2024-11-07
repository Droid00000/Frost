# frozen_string_literal: true

require 'discordrb'
require 'data/constants'
require 'data/functions'

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

  filtered_members = data.options['members'].to_a.reject do |member|
    data.bot.member(data.server, member).highest_role >= event.user.highest_role
  end

  if filtered_members.empty?
    data.edit_response(content: RESPONSE[71])
    return
  end

  bans = data.server.bulk_ban(members: filtered_members,
                              messages: data.options['messages'],
                              reason: data.options['reason'])

  data.edit_response(content: "#{RESPONSE[70]} #{bans.users.count}")
end
