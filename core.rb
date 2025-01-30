# frozen_string_literal: true

$LOAD_PATH.unshift Dir.pwd

require "yaml"
require "sequel"
require "calliope"
require "discordrb"
require "tzinfo/data"
require "unicode/emoji"
require "rufus-scheduler"
require "selenium-webdriver"
require "app/frost/models/embeds"
require "app/frost/models/constants"
require "app/frost/models/functions"
require "app/frost/models/paginator"
require "app/frost/models/extensions"
require "app/frost/pins/auto_archiver"
require "app/frost/pins/manual_archiver"

Dir["app/frost/database/*.rb"].each { |file| require file }

Dir["app/frost/**/handler.rb"].each { |file| require file }

@bot = Discordrb::Bot.new(token: CONFIG["Discord"]["TOKEN"], intents: 34_443)

at_exit { @bot.stop }

@bot.include! PinArchiver
@bot.include! BoosterPerks
@bot.include! MusicCommands
@bot.include! EmojiCommands
@bot.include! AdminCommands
@bot.include! SnowballFights
@bot.include! BirthdayCommands
@bot.include! AffectionCommands
@bot.include! ModerationCommands

@bot.run
