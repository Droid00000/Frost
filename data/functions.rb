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

require_relative './embeds'
require_relative './schema'
require_relative './constants'

# Public method. Initilaze a new color object for a role.
# @param [String] The hex color to resolve into a color object.
# @return [ColourRGB] A colourRGB object.
def resolve_color(string)
  return nil if string.nil? || !string.match(REGEX[88]) || string.empty?

  data = string.strip.delete_prefix('#')
  Discordrb::ColourRGB.new(data.strip)
end

# Public method. Used to convert a unix timestap into a readable timestamp.
# @param time [Integer] The unix timestamp to covert.
# @return [String] Time data serialized as a string.
def time_data(timestamp)
  parsed_time = Time.parse(timestamp)
  unix_time = Time.at(parsed_time&.to_i)
  unix_time.strftime('%m/%d/%Y %H:%M')
end

# Public method. Returns true if a string doesn't contain any bad words.
# @param [String] The string to check.
# @return [Boolean] True if the name doesn't contain any bad words, false if it does.
def safe_name?(string)
  return true if string.nil? || string.empty?

  !string.match(REGEX[99])
end

# Private method. Used to download and write an image to a tempfile object.
# @param link [String] The CDN URL of the emoji to download.
# @param name [String] The emoji ID serialized as a string.
# @return [File] The file path of a temporary file object.
def _resolve_icon(link, name)
  return false if Faraday.get(link).status == 404

  Tempfile.create(name) do |data|
    data.write(Faraday.get(link).body)
    data.rewind
    data.path
  end
end

# Public method. Used to abstract away the process or retriving a role icon.
# @param [String] The emoji string serialized as a parased mention.
# @return [File] The file path of a temporary file object.
def find_icon(string)
  return false if string.nil? || string.empty?

  emoji = string.match(REGEX[66])
  return false if emoji.nil?

  _resolve_icon("#{Discordrb::API.cdn_url}/emojis/#{emoji[1]}.png", emoji[1])
end

# Public method. Used to return a random GIF link for affection and snowball commands.
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
  else
    UI[21]
  end
end

# Public method. Used to determine if a server has unlocked role icons based on boost level.
# @param [Integer] The current boost level of the server.
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

# Public method. Used to determine the suffix to use at the end of a date.
# @param [Integer] The date to add a suffix to.
# @return [String] The appropriate suffix.
def add_suffix(day)
  case day
  when 1, 21, 31
    "st"
  when 2, 22
    "nd"
  when 3, 23
    "rd"
  else
    "th"
  end
end

# Public method. Used to extract a date from a website and then used to update a guild channel's name.
# @param type [Symbol] An optional type argument. 
def next_chapter_date(type: nil)
  driver = Selenium::WebDriver.for :chrome, options:
  Selenium::WebDriver::Options.chrome(args: ['--headless=new'])

  driver.get TOML['Chapter']['LINK']
  date = Date.parse(driver.page_source.match(REGEX[77])[0].strip)
  modifiy_guild_channel("📖 #{date.strftime('%B %d')}#{add_suffix(date.day)} 3PM GMT")
  driver.quit
end

# Public method. Used to make an API request to update a guild role. All JSON parameters are optional.
# @param server_id [Integer] The ID of the guild that the role is on.
# @param user_id [Integer] The ID of the user that has this role.
# @param name [String] The new name of the role.
# @param color [Integer] The new color of the role.
# @param icon [String, #Read] The new icon of the role.
# @param reason [String] The reason for editing this role.
def modify_guild_role(server_id, user_id, name: nil, color: nil, icon: nil)
  if !icon.nil? && find_icon(icon)
    image = find_icon(icon)
    image_string = File.open("/private#{image}", 'rb')

    if image.respond_to?(:read)
      image_string = 'data:image/png;base64,'
      image_string += Base64.strict_encode64(image.read)
    end
  else
    image_string = nil
  end

  color_data = (resolve_color(color) unless color.nil?)&.combined

  Discordrb::API.request(
    :guilds_sid_roles_rid,
    server_id,
    :patch,
    "#{Discordrb::API.api_base}/guilds/#{server_id}/roles/#{booster_records(server: server_id, user: user_id, type: :get_role)}",
    { color: color_data, name: name, hoist: nil, mentionable: nil, permissions: nil, icon: image_string }.compact.to_json,
    Authorization: TOML['Discord']['BOT_TOKEN'],
    content_type: :json,
    'X-Audit-Log-Reason': RESPONSE[200]
  )
end

# Public method. Used to make an API request to delete a role from a guild.
# @param server_id [Integer] The ID of the guild that the role is on.
# @param user_id [Integer] The ID of the user that has this role.
def delete_guild_role(server_id, user_id)
  Discordrb::API.request(
    :guilds_sid_roles_rid,
    server_id,
    :delete,
    "#{Discordrb::API.api_base}/guilds/#{server_id}/roles/#{booster_records(server: server_id, user: user_id, type: :get_role)}",
    Authorization: TOML['Discord']['BOT_TOKEN'],
    'X-Audit-Log-Reason': RESPONSE[300]
  )
end

# Public method. Used to update a channel name. For privacy reasons, I'll be keeping the reason to myself.
# @param name [String] The new name of the channel.
def modifiy_guild_channel(name)
  Discordrb::API.request(
    :channels_cid,
    :channel_id,
    :patch,
    "#{Discordrb::API.api_base}/channels/#{TOML['Chapter']['CHANNEL']}",
    { name: name }.compact.to_json,
    Authorization: TOML['Discord']['BOT_TOKEN'],
    content_type: :json,
    'X-Audit-Log-Reason': RESPONSE[405]
  )
end

# Public method. Used to check if a guild member is still boosting a guild.
# @param server_id [Integer, String] The ID of the guild that this guild member belongs to.
# @param user_id [Integer, String] The ID that uniquely identifies this user across discord.
# @return [Boolean] Returns true if the user is boosting the server, and false if the user is not.
def get_booster_status(server_id, user_id)
  !JSON.parse(Discordrb::API.request(
                :users_sid,
                user_id,
                :get,
                "#{Discordrb::API.api_base}/guilds/#{server_id}/members/#{user_id}",
                Authorization: TOML['Discord']['BOT_TOKEN']
              ))['premium_since'].nil?
rescue Discordrb::Errors::UnknownMember, RestClient::NotFound, Discordrb::Errors::UnknownUser
  false
end
