# frozen_string_literal: true

module General
  # Prune deleted roles.
  def self.roles(data)
    # Remove the deleted role from any server boosters.
    POSTGRES[:guild_boosters].where(guild_id: data.server.id, role_id: data.id).delete

    # Remove the deleted role from server booster settings.
    POSTGRES[:booster_settings].where(guild_id: data.server.id, role_id: data.id).delete

    # Remove the deleted role from birthday settings.
    POSTGRES[:birthday_settings].where(guild_id: data.server.id, role_id: data.id).delete
  end

  # Prune deleted channels.
  def self.channels(data)
    # Remove the deleted channel from birthday settings.
    POSTGRES[:birthday_settings].where(guild_id: data.server.id, channel_id: data.id).update(channel_id: nil)
  end
end
