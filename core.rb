# frozen_string_literal: true

$LOAD_PATH.unshift Dir.pwd

require "yaml"
require "sequel"
require "discordrb"
require "tzinfo/data"
require "unicode/emoji"
require "rufus-scheduler"
require "selenium-webdriver"
require "frost/application/mappings"

Dir["frost/**/*.rb"].each { |file| require file }

@bot = Discordrb::Bot.new(token: CONFIG[:Discord][:TOKEN], intents: 34_443)

at_exit { @bot.stop }

@bot.include! PinCommands
@bot.include! EmojiCommands
@bot.include! AdminCommands
@bot.include! BoosterCommands
@bot.include! BirthdayCommands
@bot.include! AffectionCommands
@bot.include! ModerationCommands

@bot.run
