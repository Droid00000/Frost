# frozen_string_literal: true

require_relative '../data/constants'
require 'discordrb'

class Status
  # A Hash to store the current status data.
  @@status_data = { status: nil, availability: nil }

  # @param status [String]
  # @param avalibility [String]
  def initialize(availability, status, *playing)
    @@status_data[:status] = status
    @@status_data[:availability] = availability.downcase
  end

  # Fetches the current status from the cache.
  # @return [String] The current status of the bot.
  def self.status
    @@status_data[:status]
  end

  # Fetches the current avalibility from the cache.
  # @return [String] The current avalibility of the bot.
  def self.availability
    @@status_data[:availability]
  end
end

def update_status(data)
  unless safe_name?(data.options['description'])
    data.edit_response(content: RESPONSE[502])
    return
  end

  unless TOML['Discord']['CONTRIBUTORS'].include?(data.user.id)
    data.edit_response(content: RESPONSE[503])
    return
  end

  if !data.options['description'].nil?
    data.bot.update_status(Status.availability, data.options['description'], ACTIVITY[70])
    Status.new(Status.availability, data.options['description'], ACTIVITY[70])
  end

  if !data.options['type'].nil?
    data.bot.update_status(data.options['type'].downcase, Status.status, ACTIVITY[70])
    Status.new(data.options['type'], Status.status, ACTIVITY[70])
  end

  data.edit_response(content: "#{RESPONSE[504]} #{EMOJI[10]}")
end
