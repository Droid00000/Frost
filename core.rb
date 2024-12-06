# frozen_string_literal: true

$LOAD_PATH.unshift Dir.pwd

require 'yaml'
require 'sequel'
require 'discordrb'
require 'rufus-scheduler'
require 'selenium-webdriver'
require 'src/frost/model/embeds'
require 'src/frost/model/schema'
require 'src/frost/model/functions'
require 'src/frost/pins/auto_archiver'
require 'src/frost/pins/manual_archiver'

Dir['src/frost/**/handler.rb'].each { |file| require file }

bot = Discordrb::Bot.new(token: CONFIG['Discord']['TOKEN'], intents: 33_281)

at_exit { bot.stop }

bot.include! EventRoles
bot.include! BoosterPerks
bot.include! EmojiCommands
bot.include! AdminCommands
bot.include! SnowballFights
bot.include! AutoPinArchiver
bot.include! AffectionCommands
bot.include! ManualPinArchiver
bot.include! ModerationCommands

bot.run
