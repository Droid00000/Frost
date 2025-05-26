# frozen_string_literal: true

module Moderation
  # Ban multiple users.
  def self.ban(data)
    unless data.server.bot.permission?(:manage_server)
      data.edit_response(content: RESPONSE[1])
      return
    end

    unless data.server.bot.permission?(:ban_members)
      data.edit_response(content: RESPONSE[2])
      return
    end

    # The amount of time to delete messages for.
    message_sec = data.options["messages"] * 86_400

    # All the users that we want to ban, parsed by the bot.
    users = data.bot.parse_mentions(data.options["members"])

    # The x-audit-log reason shown for all the ban entries.
    reason = "#{data.options["reason"]} (ID: #{data.user.id})"

    users = users.filter_map do |user|
      if user.is_a?(Discordrb::User)
        data.server.member(user) || user
      end
    end

    members = users.select do |user|
      user.is_a?(Discordrb::Member) && !user.owner?
    end

    members.select! do |user|
      hierarchy(user) < hierarchy(data.user)
    end

    members.select! do |user|
      hierarchy(user) < hierarchy(data.server.bot)
    end

    users = members + users.select do |user|
      user.is_a?(Discordrb::User) && !user.current_bot?
    end

    users = users.each_slice(200).filter_map do |slice|
      next if slice.empty?

      data.server.bulk_ban(users: slice, reason: reason,
                           message_seconds: message_sec)
    end

    users.map! do |bans|
      bans.respond_to?(:server) ? bans.banned_users.size : 0
    end

    data.edit_response(content: plural(RESPONSE[1], users.sum))
  end
end
