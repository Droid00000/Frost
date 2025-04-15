# frozen_string_literal: true

module Boosters
  # Command handler for /booster role delete.
  def self.delete(data)
    # Check if we can manage roles.
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[47])
      return
    end

    # Check if the invoking user is boosting.
    unless data.user.boosting?
      data.edit_response(content: RESPONSE[8])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    # Check if the invoking user is banned.
    if member.banned?
      data.edit_response(content: RESPONSE[6])
      return
    end

    # Ensure our invoking user has a role.
    if member.blank?
      data.edit_response(content: RESPONSE[4])
      return
    end

    # Remove the role and the database record.
    [data.server.role(member.role)&.delete, member.delete]

    # Return the response to the user here.
    data.edit_response(content: "#{RESPONSE[3]} #{EMOJI[3]}")
  end
end
