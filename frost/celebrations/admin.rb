# frozen_string_literal: true

module Celebrations
  # Configure the celebrations feature.
  def self.birthday_admin_configure(event)
    unless event.user.can_administrate?
      event.edit_response(content: REPLY.USER_MISSING_MANAGE_PERMISSIONS)
      return
    end

    settings = BOT.birthdays_cache.fetch_guild(event.guild_id)
    role_default = settings ? [birthday_settings.role_id] : nil
    channel_default = settings ? [birthday_settings.channel_id] : nil

    event.show_modal(title: "Settings", custom_id: "birthday_settings") do |modal|
      modal.label(label: "Birthday Role", description: "The role members should be given on their birthday.") do |label|
        label.role_select(
          max_values: 1,
          required: false,
          default_values: role_default,
          custom_id: "role_#{role_default&.first || 0}"
        )
      end

      modal.label(label: "Announcement Channel", description: "The channel where birthday annoucements should be sent.") do |label|
        label.channel_select(
          max_values: 1,
          required: false,
          types: %i[text announcement],
          default_values: channel_default,
          custom_id: "channel_#{channel_default&.first || 0}"
        )
      end
    end
  end
end
