# frozen_string_literal: true

module General
  # Prune deleted roles.
  def self.roles(data)
    Frost::Roles.remove_role(data)

    Frost::Birthdays::Settings.remove(data)

    Frost::Boosters::Members.remove_role(data)

    Frost::Boosters::Settings.remove_role(data)
  end

  # Prune deleted channels.
  def self.channels(data)
    Frost::Pins.remove(data)

    Frost::Birthdays::Settings.remove_channel(data)
  end
end
