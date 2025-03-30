# frozen_string_literal: true

module Birthdays
  # Setup birthdays for the calling server.
  def self.setup(data)
    unless data.user.permission?(:administrator)
      data.edit_response(content: RESPONSE[51])
      return
    end

    unless Frost::Birthdays::Settings.role(data) || data.options["role"]
      data.edit_response(content: RESPONSE[115])
      return
    end

    payload = {
      setup_by: data.user.id,
      setup_at: Time.now.to_i,
      guild_id: data.server.id,
      role_id: data.options["role"],
      channel_id: data.options["channel"]
    }.compact

    Frost::Birthdays::Settings.setup(payload)

    data.edit_response(content: RESPONSE[108])
  end
end
