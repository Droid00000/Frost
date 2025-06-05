# frozen_string_literal: true

module Boosters
  # Responses and fields for boosters.
  RESPONSE = {
    1 => "Your role has been created! You can always edit your role using the </booster role edit:1330463676414693407> command. <:AnyaPeek_Enzo:1276327731113627679>",
    2 => "Your role couldn't be found. Please use the </booster role claim:1330463676414693407> command to claim your role.",
    4 => "Your role couldn't be created. The bot didn't have permission to move your role above this server's hoist role.",
    3 => "Your role has been deleted! Feel free to make a new role at any time. <a:YorClap_Maomao:1287269908157038592>",
    4 => "Your role has been successfully edited! <a:LoidClap_Maomao:1276327798104920175>",
    5 => "Your role couldn't be created. The maximum role limit has been reached.",
    6 => "The bot needs to have the ``manage roles`` permission to do this.",
    7 => "You've been forbidden from using booster perks in this server.",
    8 => "Your role name contains a word that may not be used.",
    9 => "You must be a server booster to use this command.",
    10 => "This server has not enabled booster perks.",
    11 => "You've already claimed your custom role."
  }.freeze

  # Application commands for boosters.
  COMMANDS = {
    1 => "`/booster role gradient`",
    2 => "`/booster role delete`",
    3 => "`/booster role claim`",
    4 => "`/booster role edit`"
  }.freeze

  # The audit log reason for boosters.
  REASON = "Booster Roles (ID: %s)"

  # Initilaze a new color object for a role.
  # @param [String] The hex color to resolve.
  # @return [ColourRGB] A colourRGB object.
  def self.to_color(color)
    return COLORS.pull(color) if COLORS.pull(color)

    return if color.nil? || !color.match?(REGEX[1])

    color = Discordrb::ColorRGB.new(color.match(REGEX[1][0]))

    color.combined.zero? ? COLORS.pull(:BLACK) : color.combined
  end

  # Returns true if a string doesn't contain any bad words.
  # @param [String] The string to check for slurs and words.
  # @return [Boolean] If the name contains any bad words.
  def self.safe_name?(name) = !name&.match?(REGEX[4])

  # Produce an audit log to show when operating on the current role.
  # @param data [Interaction] The current interaction the entry is for.
  # @return [String] A string that denotes the action type and current user ID.
  def self.reason(interaction) = format(REASON, interaction.user.id)

  # Check if we have a valid role icon.
  # @return [Boolean] If the icon is valid.
  def self.valid_icon?(data, guild)
    return 0 if [nil, String].include?(to_icon(data)&.class) || guild.any_icon?

    data.emoji("icon")&.server && data.server.emojis.key?(data.emoji("icon").id)
  end

  # Get an icon for a role.
  # @return [String, File, nil] The resolved icon.
  def self.to_icon(data)
    return nil if data.options["icon"].nil? || data.options["icon"].empty?

    data.emoji("icon")&.file || data.options["icon"].scan(Unicode::Emoji::REGEX).first
  end
end
