# frozen_string_literal: true

require 'time'
require 'date'
require 'toml-rb'
require 'discordrb'
require 'selenium-webdriver'

require_relative 'schema'
require_relative 'embeds'
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
def resolve_time(timestamp)
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

# Abstracts away the process of retriving a role icon.
# @param [String] The emoji string serialized as a parased mention.
# @return [File] The extracted emoji icon
def resolve_icon(string)
  return false if string.nil? || string.empty?

  emoji = string.match(REGEX[1])
  nil if emoji.nil?
end

# Determines a true or false value based on a random number.
# @return [Boolean] Whether the number was in the specified range.
def hit_or_miss?
  number = rand(1..10)
  false if number >= 5
  true if number <= 5
end

# Checks to make sure a YouTube URL is valid.
# @param uri [String] A YouTube URI.
# @return [Boolean]
def valid_song?(uri)
  return false if uri.nil? || uri.empty?

  ['youtu.be', 'youtube.com', 'www.youtube.com'].include?(URI(uri).host)
end

# Checks if a guild member is still boosting a guild.
# @param server [Integer, String] An ID that uniquely identifies a guild.
# @param user [Integer, String] An ID that uniquely identifies a user.
# @return [Boolean] Returns true if the user is boosting the server; false otherwise.
def get_booster_status(server, user)
  Discordrb::API::Server.resolve_booster(TOML['Discord']['TOKEN'], server, user)
end

# Deletes a role in a guild.
# @param server [Integer, String] An ID that uniquely identifies a guild.
# @param role [Integer, String] An ID that uniquely identifies a role.
def delete_guild_role(server, role)
  Discordrb::API::Server.delete_role(TOML['Discord']['TOKEN'], server, role, REASON[6])
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

# Extracts a date from a website.
# @param type [Symbol] An optional type argument that does nothing.
def next_chapter_date(type:)
  driver = Selenium::WebDriver.for :chrome, options: Selenium::WebDriver::Options.chrome(args: ['--headless=new'])
  driver.get TOML['Chapter']['LINK']

  date = Date.parse(driver.page_source.match(REGEX[2])[0].strip)
  name = "📖 #{date.strftime('%B %d')}#{add_suffix(date.day)} 3PM GMT"

  Discordrb::API::Channel.name(TOML['Discord']['TOKEN'], TOML['Chapter']['CHANNEL'], name, REASON[4])
  driver.quit
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
  when :BONK
    BONK.sample.to_s
  else
    UI[21]
  end
end

def settings(type, server)
  case type
  when :archiver
    if archiver_records(server: server, type: :check)
      then "**Archive Channel:** <##{archiver_records(server: server, type: :get)}>"
    else
      '**Enabled:** No'
    end

  when :booster
    if booster_records(server: server, type: :enabled)
      then "**Hoist Role:** <@&#{booster_records(server: server, type: :hoist_role)}>"
    else
      '**Enabled:** No'
    end
  when :events
    if event_records(server: server, type: :enabled)
      roles = event_records(server: server, type: :get_roles).map do |row|
        row.values.map { |key| "<@&#{key}>".to_s }
      end.flatten.uniq

      "**Roles:** #{roles.join(', ')}"
    else
      '**Enabled:** No'
    end
  end
end
