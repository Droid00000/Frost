# frozen_string_literal: true

$LOAD_PATH.unshift Dir.pwd

require "yaml"
require "sequel"
require "discordrb"
require "tzinfo/data"
require "unicode/emoji"
require "rufus-scheduler"
require "selenium-webdriver"
require "frost/models/embeds"
require "frost/models/constants"
require "frost/models/functions"
require "frost/models/paginator"
require "frost/models/extensions"

Dir["frost/database/*.rb"].each { |file| require file }

Dir["frost/**/handler.rb"].each { |file| require file }

@bot = Discordrb::Bot.new(token: CONFIG[:Discord][:TOKEN], intents: 34_443)

at_exit { @bot.stop }

@bot.include! PinArchiver
@bot.include! BoosterPerks
@bot.include! EmojiCommands
@bot.include! AdminCommands
@bot.include! SnowballFights
@bot.include! BirthdayCommands
@bot.include! AffectionCommands
@bot.include! ModerationCommands

@bot.run
