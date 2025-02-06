# frozen_string_literal: true

def handle_roles(data)
  Frost::Roles.remove(data)

  Frost::Birthdays::Settings.remove(data)

  Frost::Boosters::Members.remove_role(data)
  
  Frost::Boosters::Settings.remove_role(data)
end

def handle_channels(data)
  Frost::Pins.remove(data)

  Frost::Birthdays::Settings.remove_channel(data)
end
