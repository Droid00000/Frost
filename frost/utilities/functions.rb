# frozen_string_literal: true

# Initilaze a new color object for a role.
# @param [String] The hex color to resolve.
# @return [ColourRGB] A colourRGB object.
def resolve_color(color)
  return nil if color.nil? || !color.match(REGEX[2])

  color = COLORS.get(color) if COLORS.get(color)

  color = "00000c" if color.delete("#") == "000000"

  Discordrb::ColourRGB.new(color.strip.delete("#"))
end

# Returns true if a string doesn't contain any bad words.
# @param [String] The string to check for slurs and words.
# @return [Boolean] If the name contains any bad words.
def safe_name?(name)
  !name&.match(REGEX[3])
end

# Deletes a role in a guild.
# @param guild [Integer, String] An ID that uniquely identifies a guild.
# @param id [Integer, String] An ID that uniquely identifies a role.
def delete_guild_role(guild, id)
  Discordrb::API::Server.delete_role(CONFIG[:Discord][:TOKEN], guild, id, REASON[1])
rescue StandardError
  true
end

# Get an icon for a role.
# @param [icon] The icon to resolve.
# @return [String, File, nil] The resolved icon.
def resolve_icon(icon)
  return nil if icon.options["icon"].nil? || icon.options["icon"].empty?

  icon.emojis("icon")&.static_file || icon.options["icon"].scan(Unicode::Emoji::REGEX).first
end
