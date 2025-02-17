# frozen_string_literal: true

$LOAD_PATH.unshift Dir.pwd

require "yaml"
require "sequel"
require "calliope"
require "typesense"
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
require "frost/pins/auto_archiver"
require "frost/pins/manual_archiver"

Dir["frost/database/*.rb"].each { |file| require file }

Dir["frost/**/handler.rb"].each { |file| require file }

@bot = Discordrb::Bot.new(token: CONFIG[:Discord][:TOKEN], intents: 34_443)

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
