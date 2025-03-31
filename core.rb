# frozen_string_literal: true

$LOAD_PATH.unshift Dir.pwd

require "yaml"
require "sequel"
require "objspace"
require "discordrb"
require "tzinfo/data"
require "unicode/emoji"
require "rufus-scheduler"
require "selenium-webdriver"
require "frost/utilities/mappings"
require "frost/utilities/extensions"

Dir["frost/database/*.rb"].each { |file| require file }

Dir["frost/**/handler.rb"].each { |file| require file }

@bot = Discordrb::Bot.new(token: CONFIG[:Discord][:TOKEN], intents: 34_443)

at_exit { @bot.stop }

@bot.include! PinArchiver
@bot.include! EmojiCommands
@bot.include! AdminCommands
@bot.include! BoosterCommands
@bot.include! BirthdayCommands
@bot.include! AffectionCommands
@bot.include! ModerationCommands

@bot.run
