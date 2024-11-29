# frozen_string_literal: true

require 'yaml'
require 'sequel'
require 'discordrb'
require 'rufus-scheduler'
require 'selenium-webdriver'

require_relative 'embeds'
require_relative 'constants'
require_relative 'schema'
require_relative 'functions'

BASE = File.expand_path('../', __dir__)

Dir.glob("#{BASE}/*").select { |path| File.directory?(path) }.each do |folder|
  Dir["#{folder}/*.rb"].each do |file|
    next if file.include?('handler.rb') || file.include?('commands.rb')

    require file
  end
end

Dir.glob("#{BASE}/**/handler.rb").each do |handler|
  require handler
end
