# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('./', __dir__)

require 'yaml'
require 'sequel'
require 'discordrb'
require 'rufus-scheduler'
require 'selenium-webdriver'

Dir["#{File.expand_path('./', __dir__)}/*.rb"].each { |file| require file }

Dir.glob("#{File.expand_path('../', __dir__)}/*").select { |block| File.directory?(block) }.each do |folder|
  Dir["#{folder}/*.rb"].each do |file|
    next if file.include?('handler.rb') || file.include?('commands.rb')

    require file
  end

  Dir.glob("#{File.expand_path('../', __dir__)}/**/*.rb").select { |f|
    File.basename(f) == 'handler.rb'
  }.each do |file|
    require file
  end
end
