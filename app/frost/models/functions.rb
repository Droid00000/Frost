# frozen_string_literal: true

# Initilaze a new color object for a role.
# @param [String] The hex color to resolve.
# @return [ColourRGB] A colourRGB object.
def resolve_color(color)
  return nil if color.nil? || !color.match(REGEX[2])

  Discordrb::ColourRGB.new(color.strip.delete('#'))
end

# Returns true if a string doesn't contain any bad words.
# @param [String] The string to check.
# @return [Boolean] If the name contains any bad words.
def safe_name?(name)
  return true if name.nil?

  !name.match(REGEX[5])
end

# Checks if a guild member is still boosting a guild.
# @param server [Integer, String] An ID that uniquely identifies a guild.
# @param user [Integer, String] An ID that uniquely identifies a user.
# @return [Boolean] Returns true if the user is boosting the server; false otherwise.
def get_booster_status(server, user)
  Discordrb::API::Server.resolve_booster(CONFIG['Discord']['TOKEN'], server, user)
end

# Deletes a role in a guild.
# @param server [Integer, String] An ID that uniquely identifies a guild.
# @param role [Integer, String] An ID that uniquely identifies a role.
def delete_guild_role(server, role)
  Discordrb::API::Server.delete_role(CONFIG['Discord']['TOKEN'], server, role, REASON[6])
rescue StandardError
  true
end

# Returns a random GIF link for use by the affection and snowball commands.
# @param [Integer] An integer from 1-7 representing the type of action.
# @return [String] The appropriate GIF for the action.
def gif(type)
  case type
  when :ANGRY
    ANGRY.sample
  when :HUGS
    HUGS.sample
  when :NOMS
    NOMS.sample
  when :POKES
    POKES.sample
  when :SLEEPY
    SLEEPY.sample
  when :COLLECT
    COLLECT.sample
  when :THROW
    THROW.sample
  when :MISS
    MISS.sample
  when :BONK
    BONK.sample
  when :PUNCH
    PUNCH.sample
  else
    UI[21]
  end
end
