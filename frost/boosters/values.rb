# frozen_string_literal: true

module Boosters
  # Responses and fields for boosters.
  RESPONSE = {
    1 => "Your role has been created! You can always edit your role using the </booster role edit:1330463676414693407> command. <:AnyaPeek_Enzo:1276327731113627679>",
    2 => "Your role couldn't be found. Please use the </booster role claim:1330463676414693407> command to claim your role.",
    3 => "Your role has been deleted! Feel free to make a new role at any time. <a:YorClap_Maomao:1287269908157038592>",
    4 => "Your role has been successfully edited! <a:LoidClap_Maomao:1276327798104920175>",
    5 => "Your role couldn't be created. The maximum role limit has been reached.",
    6 => "You've been forbidden from using booster perks in this server.",
    7 => "Your role name contains a word that may not be used.",
    8 => "You must be a server booster to use this command.",
    9 => "This server has not enabled booster perks.",
    10 => "You've already claimed your custom role."
  }.freeze

  # Application commands for boosters.
  COMMANDS = {
    1 => "`/booster role gradient`",
    2 => "`/booster role delete`",
    3 => "`/booster role claim`",
    4 => "`/booster role edit`"
  }.freeze

  # Returns true if a string doesn't contain any bad words.
  # @param [String] The string to check for slurs and words.
  # @return [Boolean] If the name contains any bad words.
  def self.safe_name?(name)
    !name&.match?(REGEX[3])
  end

  # Initilaze a new color object for a role.
  # @param [String] The hex color to resolve.
  # @return [ColourRGB] A colourRGB object.
  def self.to_color(color)
    return COLORS.get(color) if COLORS.get(color)

    return if color.nil? || !color.match(REGEX[2])

    Discordrb::ColorRGB.new(color.strip.match(REGEX[2]))
  end

  # Check if we have a valid role icon.
  # @return [Boolean] If the icon is valid.
  def self.valid_icon?(data, guild)
    return true if [NilClass, String].any?(to_icon(data).class) || guild.any_icon?

    data.emoji("icon").server && data.emoji("icon").server.id == data.server.id
  end

  # Get an icon for a role.
  # @param [icon] The icon to resolve.
  # @return [String, File, nil] The resolved icon.
  def self.to_icon(icon)
    return nil if icon.emoji("icon").nil? || icon.options["icon"].empty?

    icon.emoji("icon").file(static: true) || icon.options["icon"].scan(Unicode::Emoji::REGEX).first
  end
end
