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

BOT = Discordrb::Bot.new(token: CONFIG[:Discord][:TOKEN], intents: 34_315)

at_exit { BOT.stop }

BOT.include! EmojiCommands
BOT.include! AdminCommands
BOT.include! BoosterCommands
BOT.include! BirthdayCommands
BOT.include! AffectionCommands
BOT.include! ModerationCommands

BOT.run
