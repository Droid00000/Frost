# frozen_string_literal: true

module Roles
  # Responses and fields for vanity roles.
  RESPONSE = {
    1 => "The role couldn't be edited. The bot's highest role is below the provided role.",
    2 => "The role has been successfully edited! <a:LoidClap_Maomao:1276327798104920175>",
    3 => "The bot needs to have the `manage roles` permission to do this.",
    4 => "You need to have the `manage roles` permission to do this.",
    5 => "Please provide a start **and** end color for the gradient.",
    6 => "You don't have the required permissions to do this.",
    7 => "The role name contains a word that cannot be used.",
    8 => "Please provide a start color for the gradient.",
    9 => "Please provide an end color for the gradient.",
    10 => "Vanity roles have been successfully updated.",
    11 => "Vanity roles have been successfully enabled.",
    12 => "Vanity roles have been successfully disabled."
  }.freeze

  # Application commands for vanity roles.
  COMMANDS = {
    1 => "`/vanity role gradient`",
    2 => "`/booster role edit`"
  }.freeze

  # The holographic style colors.
  HOLOGRAPHIC = {
    colour: 11_127_295,
    secondary: 16_759_788,
    tertiary: 16_761_760
  }.freeze

  # The audit log reason for vanity roles.
  REASON = "Vanity Roles (ID: %s)"

  # Initilaze a new color object for a role.
  # @param [String] The hex color to resolve.
  # @return [ColourRGB] A colourRGB object.
  def self.to_color(color)
    return COLORS.pull(color) if COLORS.pull(color)

    return if color.nil? || !color.match?(REGEX[1])

    color = Discordrb::ColorRGB.new(color.match(REGEX[1])[0])

    color.combined.zero? ? COLORS.pull(:BLACK) : color.combined
  end

  # Returns true if a string doesn't contain any bad words.
  # @param [String] The string to check for slurs and words.
  # @return [Boolean] If the name contains any bad words.
  def self.safe_name?(name) = !name&.match?(REGEX[4])

  # Produce an audit reason log to show when operating on the current role.
  # @param interaction [Interaction] The current interaction the entry is for.
  # @return [String] A string that denotes the action type and current user ID.
  def self.reason(interaction) = format(REASON, interaction.user.id)

  # Check if a member has permission to modify a given role.
  # @param member [Discordrb::Member] The member to check for exemption.
  # @param guild [Roles::Guild] The guild to fallback to for checking.
  # @return [true, false] Whether the member can modify the given role.
  def self.exempt?(member, guild)
    return true if member.permission?(:manage_roles)

    guild.blank? ? false : member.role?(guild.exempt_role)
  end

  # Get an icon for a role.
  # @return [String, File, nil] The resolved icon.
  def self.to_icon(data)
    return nil if data.options["icon"].nil? || data.options["icon"].empty?

    data.emoji("icon")&.file || data.options["icon"].scan(Unicode::Emoji::REGEX).first
  end
end
