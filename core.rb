# frozen_string_literal: true

$LOAD_PATH.unshift Dir.pwd

require 'yaml'
require 'sequel'
require 'discordrb'
require 'rufus-scheduler'
require 'selenium-webdriver'
require 'app/frost/models/embeds'
require 'app/frost/models/schema'
require 'app/frost/models/functions'
require 'app/frost/pins/auto_archiver'
require 'app/frost/pins/manual_archiver'

Dir['app/frost/**/handler.rb'].each { |file| require file }

bot = Discordrb::Bot.new(token: CONFIG['Discord']['TOKEN'], intents: 33_281)

at_exit { bot.stop }

bot.include! EventRoles
bot.include! PinArchiver
bot.include! BoosterPerks
bot.include! EmojiCommands
bot.include! AdminCommands
bot.include! SnowballFights
bot.include! AffectionCommands
bot.include! ModerationCommands

bot.run
