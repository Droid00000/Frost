# frozen_string_literal: true

module AdminCommands
  # namespace for event roles.
  module Roles
    # Responses and fields for event roles.
    RESPONSE = {
      1 => "The role has been successfully edited! <a:LoidClap_Maomao:1276327798104920175>",
      2 => "The bot needs to have the `manage roles` permission to do this.",
      3 => "You need to have the `manage roles` permission to do this.",
      4 => "The `icon` option must be provided when setting up a role.",
      5 => "Event perks cannot be enabled for the @еveryone role.",
      6 => "The role name contains a word that may not be used.",
      7 => "This role hasn't been configured to be editable.",
      8 => "Successfully disabled event perks for the role!",
      9 => "Successfully enabled event perks for the role!",
      10 => "Successfully updated event perks for the role!",
      11 => "Only members of this role may edit it."
    }.freeze

    # Application commands for event roles.
    COMMANDS = {
      1 => "`/event role gradient`",
      2 => "`/event role disable`",
      3 => "`/event role enable`",
      4 => "`/event role edit`"
    }.freeze

    # Returns true if a string doesn't contain any bad words.
    # @param [String] The string to check for slurs and words.
    # @return [Boolean] If the name contains any bad words.
    def self.safe_name?(name)
      !name&.match?(REGEX[4])
    end

    # Initilaze a new color object for a role.
    # @param [String] The hex color to resolve.
    # @return [ColourRGB] A colourRGB object.
    def self.to_color(color)
      return COLORS.pull(color) if COLORS.pull(color)

      return if color.nil? || !color.match?(REGEX[1])

      color = Discordrb::ColorRGB.new(color.match(REGEX[1][0]))

      color.combined.zero? ? COLORS.pull(:BLACK) : color.combined
    end

    # Check if we have a valid role icon.
    # @return [Boolean] If the icon is valid.
    def self.valid_icon?(data, role)
      return 0 if [nil, String].include?(to_icon(data)&.class) || role.any_icon?

      data.emoji("icon").server && data.emoji("icon").server.id == data.server.id
    end

    # Get an icon for a role.
    # @param data [Interaction] The icon to resolve.
    # @return [String, File, nil] The resolved icon.
    def self.to_icon(data)
      return nil if data.options["icon"].nil? || data.options["icon"].empty?

      data.emoji("icon").file || data.options["icon"].scan(Unicode::Emoji::REGEX).first
    end
  end
end
