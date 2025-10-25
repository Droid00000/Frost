# frozen_string_literal: true

module Boosters
  # Responses and fields for boosters.
  RESPONSE = {
    1 => "Your role has been created! You can always edit your role using the </booster role edit:1386237785865850941> command. <:AnyaPeek_Enzo:1276327731113627679>",
    2 => "Your role couldn't be found. Please use the </booster role claim:1386237785865850941> command to claim your role.",
    3 => "Your role couldn't be created. The bot doesn't have permission to move your role above this server's hoist role.",
    4 => "Your role has been deleted! Feel free to make a new role at any time. <a:YorClap_Maomao:1287269908157038592>",
    5 => "Your role couldn't be deleted. The bot's highest role is below your custom role.",
    6 => "Your role couldn't be edited. The bot's highest role is below your custom role.",
    7 => "Your role has been successfully edited! <a:LoidClap_Maomao:1276327798104920175>",
    8 => "Your role couldn't be created. The maximum role limit has been reached.",
    9 => "Your role couldn't be created. This server's hoist role was deleted.",
    10 => "The bot needs to have the `manage roles` permission to do this.",
    11 => "You've been banned from using booster perks in this server.",
    12 => "Please provide a start **and** end color for your gradient.",
    13 => "Please provide a start **or** end color for your gradient.",
    14 => "Your role name contains a word that cannot be used.",
    15 => "You must be a server booster to use this command.",
    16 => "Please provide a start color for your gradient.",
    17 => "Please provide an end color for your gradient.",
    18 => "This server hasn't enabled booster perks.",
    19 => "You've already claimed your custom role."
  }.freeze

  # The holographic style colors.
  HOLOGRAPHIC = {
    colour: 11_127_295,
    secondary: 16_759_788,
    tertiary: 16_761_760
  }.freeze

  # Initilaze a new color object for a role.
  # @param [String] The hex color to resolve.
  # @return [ColourRGB] A colourRGB object.
  def self.to_color(color)
    return COLORS.pull(color) if COLORS.pull(color)

    return if color.nil? || !(color = color[REGEX[1]])

    color.to_i(16).zero? ? COLORS[:black] : color.to_i(16)
  end

  # Produce an audit reason log to show when operating on the current role.
  # @return [String] A string that denotes the action type and current user ID.
  def self.reason(data)
    "Booster Roles (ID: #{data.user.resolve_id})"
  end

  # Check if a custom emoji is a valid icon for a role.
  # @return [File, nil] the file for the custom emoji that can be used as the icon.
  def self.safe_icon?(icon, state, source)
    icon.file if state || source[icon.resolve_id]
  end

  # Returns true if a string doesn't contain any bad words.
  # @return [true, false] If the name contains any bad words.
  def self.safe_name?(data)
    return true if data.options["name"].nil? || data.options["name"].empty?

    !data.options["name"].unicode_normalize(:nfkd).gsub(/\p{Mn}/, "").match?(REGEX[5])
  end

  # Get an icon for a role.
  # @return [String, File, nil] The resolved icon.
  def self.to_icon(data, guild)
    return nil unless data.server.features.include?(:role_icons)

    icon = (data.emoji("icon") || data.options["icon"]&.scan(Unicode::Emoji::REGEX)&.first)

    icon.is_a?(Discordrb::Emoji) ? safe_icon?(icon, guild.any_icon?, data.server.emojis) : icon
  end
end
