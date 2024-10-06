# frozen_string_literal: true

require 'time'
require 'json'
require 'date'
require 'base64'
require 'faraday'
require 'toml-rb'
require 'tempfile'
require 'discordrb'
require 'selenium-webdriver'

require_relative 'embeds'
require_relative 'schema'
require_relative 'constants'

# Initilaze a new color object for a role.
# @param [String] The hex color to resolve.
# @return [ColourRGB] A colourRGB object.
def resolve_color(string)
  return nil if string.nil? || !string.match(REGEX[88]) || string.empty?

  data = string.strip.delete_prefix('#')
  Discordrb::ColourRGB.new(data.strip)
end

# Used to convert a unix timestap into a readable timestamp.
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

  !string.match(REGEX[99])
end

# abstracts away the process or retriving a role icon.
# @param [String] The emoji string serialized as a parased mention.
# @return [File] The file path of a temporary file object.
def find_icon(string)
  return false if string.nil? || string.empty?

  emoji = string.match(REGEX[66])
  return :undef if emoji.nil?

  return :undef if Faraday.get("#{cdn_url}/emojis/#{emoji[1]}.png").status == 404

  Tempfile.create(emoji[1]) do |data|
    data.write(Faraday.get("#{cdn_url}/emojis/#{emoji[1]}.png").body)
    data.rewind
    data.path
  end
end

# Return a random GIF link for use by the affection and snowball commands.
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

# Modifies a role on a server.
# @param server [Integer] ID of the server.
# @param role [Integer] ID of the role.
# @param reason [String] Reason for updating this role.
# @param name [String] New name of the role.
# @param color [String] New color of the role.
# @param icon [String] New icon of the role.
def modifiy_role(server, role, reason, name:, color:, icon:)
  icon = resolve_icon(icon) ? "data:image/png;base64,#{Base64.strict_encode64(image.read)}" : :undef
  color = resolve_color(color).combined ? color : :undef
  name ||= :undef

  client.modify_guild_role(server, role, reason, name: name, color: color, icon: icon)
end

# Returns a server member.
# @param server [Integer] ID of the server.
# @param booster [Integer] ID of the member.
def get_booster(guild, booster)
  client.get_guild_member(guild, booster)
end

# Deletes a role on a server.
# @param server [Integer] ID of the server.
# @param role [Integer] ID of the role.
def delete_role(server, role)
  client.delete_guild_role(guild_id, role, REASON[3])
end

# Extracts a date from a website and then used to update a guild channel's name.
# @param channel [Integer] The channel to update.
def next_chapter_date(channel)
  driver = Selenium::WebDriver.for :chrome, options: Selenium::WebDriver::Options.chrome(args: ['--headless=new'])
  driver.get TOML['Chapter']['LINK']

  date = Date.parse(driver.page_source.match(REGEX[2])[0].strip)
  name = "📖 #{date.strftime('%B %d')}#{add_suffix(date.day)} 3PM GMT"

  modify_channel(channel, name)
  driver.quit
end

# Modifies the name of a channel.
# @param channel [Integer] The channel to update.
# @param name [String] The new name of the channel.
def modify_channel(channel, name)
  client.modify_guild_channel(channel, name, REASON[13])
end
