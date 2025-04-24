# frozen_string_literal: true

module Boosters
  # Command handler for /booster role delete.
  def self.delete(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[47])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[8])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    if member.banned?
      data.edit_response(content: RESPONSE[6])
      return
    end

    if member.blank?
      data.edit_response(content: RESPONSE[4])
      return
    end

    [data.server.role(member.role)&.delete, member.delete]

    data.edit_response(content: "#{RESPONSE[3]} #{EMOJI[3]}")
  end
end
