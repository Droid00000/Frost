# frozen_string_literal: true

require "yaml"
require "sequel"
require "discordrb"
require "tzinfo/data"
require "unicode/emoji"
require "rufus-scheduler"
require "selenium-webdriver"

Dir["frost/**/*.rb"].each { |file| require_relative file }

# TODO: rebase back onto shardlab/discordrb main version branch.
BOT = Discordrb::Bot.new(token: CONFIG[:Discord][:TOKEN], intents: 34_313)

s = OpenSSL::X509::Store.new.tap(&:set_default_paths)
OpenSSL::SSL::SSLContext.send(:remove_const, :DEFAULT_CERT_STORE) rescue nil
OpenSSL::SSL::SSLContext.const_set(:DEFAULT_CERT_STORE, s.freeze)

at_exit { BOT.stop }

BOT.include! AdminCommands
BOT.include! BoosterCommands
BOT.include! BirthdayCommands
BOT.include! AffectionCommands
BOT.include! ModerationCommands

BOT.run
