# frozen_string_literal: true

module Boosters
  # Delete a role for a guild booster. This command takes zero parameters.
  #
  # @note [1] There are several things to consider when this command is used.
  #   Firstly, all of the operations in this command are performed asynchronously.
  #
  # @note [2] Secondly, if the bot's permissions are changed during the middle
  #   of a delete operation, the response will change to show an error after the
  #   success message. I hope to find a solution to this bad experience in the future.
  #
  # @note [3] Lastly, if the bot is unable to delete the user's role, we intentionally
  #   do not remove the role from the DB. This is because we most likely do not want
  #   the user to have a role that can out-last their boosting duration.
  def self.delete(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[10])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[15])
      return
    end

    unless Guild.get(data)
      data.edit_response(content: RESPONSE[18])
      return
    end

    unless (member = Booster.get(data))
      data.edit_response(content: RESPONSE[2])
      return
    end

    if member.banned?
      data.edit_response(content: RESPONSE[11])
      return
    end

    begin
      member.role&.delete(member.reason)
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[5])
      return
    end

    data.edit_response(content: RESPONSE[4])

    Booster.delete(data)
  end
end
