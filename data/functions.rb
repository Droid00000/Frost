# frozen_string_literal: true

require 'time'
require 'date'
require 'base64'
require 'faraday'
require 'toml-rb'
require 'tempfile'
require 'discordrb'
require 'selenium-webdriver'

require_relative 'embeds'
require_relative 'schema'
require_relative 'requests'
require_relative 'constants'

# Initilaze a new color object for a role.
# @param [String] The hex color to resolve.
# @return [ColourRGB] A colourRGB object.
def resolve_color(string)
  return nil if string.nil? || !string.match(REGEX[3]) || string.empty?

  data = string.strip.delete_prefix('#')
  Discordrb::ColourRGB.new(data.strip).combined
end

# Converts a unix timestap into a readable timestamp.
# @param timestamp [Integer] The unix timestamp to covert.
# @return [String] Time data serialized as a string.
def time_data(timestamp)
  parsed_time = Time.parse(timestamp)
  unix_time = Time.at(parsed_time&.to_i)
  unix_time.strftime('%m/%d/%Y %H:%M')
end

# Returns true if a string doesn't contain any bad words.
# @param [String] The string to check.
# @return [Boolean] If the name contains any bad words.
def safe_name?(string)
  return true if string.nil? || string.empty?

  !string.match(REGEX[4])
end

# Abstracts away the process or retriving a role icon.
# @param [String] The emoji string serialized as a parased mention.
# @return [File] The file path of a temporary file object.
def find_icon(string)
  return false if string.nil? || string.empty?

  emoji = string.match(REGEX[1])
  return nil if emoji.nil?

  return nil if Faraday.get("#{Discordrb::API.cdn_url}/emojis/#{emoji[1]}.png").status == 404

  file = Tempfile.new(emoji[1])
  file.write(Faraday.get("#{Discordrb::API.cdn_url}/emojis/#{emoji[1]}.png").body)
  file.rewind
  File.expand_path(file.path)
end

# Returns a random GIF link for use by the affection and snowball commands.
# @param [Integer] An integer from 1-7 representing the type of action.
# @return [String] The appropriate GIF for the action.
def gif(type)
  case type
  when :ANGRY
    ANGRY.sample.to_s
  when :HUGS
    HUGS.sample.to_s
  when :NOMS
    NOMS.sample.to_s
  when :POKES
    POKES.sample.to_s
  when :SLEEPY
    SLEEPY.sample.to_s
  when :COLLECT
    COLLECT.sample.to_s
  when :THROW
    THROW.sample.to_s
  when :MISS
    MISS.sample.to_s
  else
    UI[21]
  end
end

# Determines if a server has unlocked role icons based on its boost level.
# @param boost_level [Integer] The current boost level of the server.
# @return [Boolean] True if the server can have role icons, false otherwise.
def unlocked_icons?(boost_level)
  case boost_level
  when 0
    false
  when 1
    false
  when 2
    true
  when 3
    true
  else
    false
  end
end

# Determines the suffix to use at the end of a date.
# @param day [Integer] The date to add a suffix to.
# @return [String] The appropriate suffix.
def add_suffix(day)
  case day
  when 1, 21, 31
    'st'
  when 2, 22
    'nd'
  when 3, 23
    'rd'
  else
    'th'
  end
end

# Determines a true or false value based on a random number.
# @return [Boolean] Whether the number was in the specified range.
def hit_or_miss?
  number = rand(1..10)
  false if number >= 5
  true if number <= 5
end

# Extracts a date from a website.
# @param channel [Integer] The channel to update.
def next_chapter_date(channel)
  driver = Selenium::WebDriver.for :chrome, options: Selenium::WebDriver::Options.chrome(args: ['--headless=new'])
  driver.get TOML['Chapter']['LINK']

  date = Date.parse(driver.page_source.match(REGEX[2])[0].strip)
  modify_guild_channel("📖 #{date.strftime('%B %d')}#{add_suffix(date.day)} 3PM GMT")

  driver.quit
end

# Makes an API request to update a guild role. All JSON parameters are optional.
# @param server_id [Integer] The ID of the guild that the role is on.
# @param user_id [Integer] The ID of the user that has this role.
# @param name [String] The new name of the role.
# @param color [Integer] The new color of the role.
# @param icon [String, #Read] The new icon of the role.
# @param role [Integer] The role to be modified.
# @param type [Symbol] The type of edit to perform.
def modify_guild_role(server: nil, user: nil, name: nil, color: nil, icon: nil, role: nil, type: nil)
  if !icon.nil? && find_icon(icon)
    image = find_icon(icon)
    image_string = File.open("#{image}", 'rb')

    if image.respond_to?(:read)
      image_string = 'data:image/png;base64,'
      image_string += Base64.strict_encode64(image.read)
    end
  else
    image_string = nil
  end

  color_data = (resolve_color(color) unless color.nil?)

  case type
  when :booster
    Frigid::Requests.booster_roles(user, server, color: color_data, name: name, icon: image_string)
  when :event
    Frigid::Requests.event_roles(role, color: color_data, name: name, icon: image_string)
  end
end

# Makes an API request to delete a role from a guild.
# @param server_id [Integer] The ID of the guild that the role is on.
# @param user_id [Integer] The ID of the user that has this role.
def delete_guild_role(server_id, user_id)
  Frigid::Requests.delete_role(server_id, user_id)
end

# Updates the name of a channel.
# @param name [String] The new name of the channel.
def modifiy_guild_channel(name)
  Frigid::Requests.update_channel(name)
end

# Checks if a guild member is still boosting a guild.
# @param server_id [Integer, String] The ID of the guild that this guild member belongs to.
# @param user_id [Integer, String] The ID that uniquely identifies this user across discord.
# @return [Boolean] Returns true if the user is boosting the server, and false if the user is not.
def get_booster_status(server_id, user_id)
  Frigid::Requests.booster_status(server_id, user_id)
end
