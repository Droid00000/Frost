# frozen_string_literal: true

module Boosters
  # Responses and fields for boosters.
  RESPONSE = {
    1 => "Your role has been created! You can always edit your role using the </booster role edit:1330463676414693407> command. <:AnyaPeek_Enzo:1276327731113627679>",
    2 => "Your role has been successfully deleted! Feel free to make a new role at any time. <a:YorClap_Maomao:1287269908157038592>",
    3 => "Your role couldn't be found. Please use the </booster role claim:1330463676414693407> command to claim your role.",
    4 => "Your role has been successfully edited! <a:LoidClap_Maomao:1276327798104920175>",
    5 => "Your role couldn't be created. The maximum role limit has been reached.",
    6 => "You've been banned from using booster perks in this server.",
    7 => "This server has not enabled perks for server boosters.",
    8 => "Your role name contains a word that cannot be used.",
    9 => "You must be a server booster to use this command.",
    10 => "You've already claimed your custom role."
  }.freeze

  # Application commands for boosters.
  COMMANDS = {
    2 => "`/booster role delete`",
    1 => "`/booster role claim`",
    3 => "`/booster role edit`"
  }.freeze

  # Returns true if a string doesn't contain any bad words.
  # @param [String] The string to check for slurs and words.
  # @return [Boolean] If the name contains any bad words.
  def self.safe_name?(name)
    !name&.match(REGEX[3])
  end

  # Initilaze a new color object for a role.
  # @param [String] The hex color to resolve.
  # @return [ColourRGB] A colourRGB object.
  def self.resolve_color(color)
    color = COLORS.get(color) if COLORS.get(color)

    return nil if color.nil? || !color.match(REGEX[2])

    color = "00000c" if color.delete("#") == "000000"

    Discordrb::ColourRGB.new(color.strip.delete("#"))
  end

  # Check if we have a valid role icon.
  # @return [Boolean] If the icon is valid.
  def self.valid_icon?(data)
    return true if Frost::Boosters.settings.any_icon?(data)

    return true if [NilClass, String].include?(resolve_icon(data).class)

    data.emojis("icon").server && data.emojis("icon").server.id == data.server.id
  end

  # Get an icon for a role.
  # @param [icon] The icon to resolve.
  # @return [String, File, nil] The resolved icon.
  def self.resolve_icon(icon)
    return nil if icon.options["icon"].nil? || icon.options["icon"].empty?

    icon.emojis("icon")&.static_file || icon.options["icon"].scan(Unicode::Emoji::REGEX).first
  end
end
