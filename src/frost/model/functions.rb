# frozen_string_literal: true

require 'embeds'
require 'discordrb'
require 'constants'
require 'rufus-scheduler'
require 'selenium-webdriver'

# Initilaze a new color object for a role.
# @param [String] The hex color to resolve.
# @return [ColourRGB] A colourRGB object.
def resolve_color(color)
  return nil if color.nil? || !color.match(REGEX[2])

  Discordrb::ColourRGB.new(color.strip.delete('#'))
end

# Converts a unix timestap into a readable timestamp.
# @param timestamp [Integer] The unix timestamp to covert.
# @return [String] Time data serialized as a string.
def resolve_time(timestamp)
  parsed_time = Time.parse(timestamp)
  unix_time = Time.at(parsed_time&.to_i)
  unix_time.strftime('%m/%d/%Y, %H:%M')
end

# Returns true if a string doesn't contain any bad words.
# @param [String] The string to check.
# @return [Boolean] If the name contains any bad words.
def safe_name?(name)
  return true if name.nil?

  !name.match(REGEX[3])
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
rescue Dsicordrb::Errors::NotFound
  true
end

# Similar to Python imports. Requires a file.
# @param file [String] Name of the file to import.
def import(file)
  require "#{File.dirname(caller.first)}/#{file}"
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
