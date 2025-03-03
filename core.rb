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
require "frost/models/extensions"

Dir["frost/database/*.rb"].each { |file| require file }

Dir["frost/**/handler.rb"].each { |file| require file }

@bot = Discordrb::Bot.new(token: CONFIG[:Discord][:TOKEN], intents: 34_443)

at_exit { @bot.stop }

@bot.register_application_command(:purge, "Moderation Commands", contexts: [0], integration_types: [0], name_localizations: { "hi" => "शुद्ध" }, description_localizations: { "hi" => "मॉडरेशन आदेश" }, default_member_permissions: "10256") do |command|
    command.subcommand("messages", "Remove messages that meet a criteria.", name_localizations: { "hi" => "सूचना" }, description_localizations: { "hi" => "वर्तमान चैनल में संदेश हटाएँ" }) do |option|
      option.integer("amount", "The maximum number of messages to delete.", required: true, min_value: 1, max_value: 700, name_localizations: { "hi" => "रकम" }, description_localizations: { "hi" => "आप कितने मैसेज डिलीट करना चाहते हैं" })
      option.user("member", "Remove messages from a specific user.", required: false, name_localizations: { "hi" => "सदस्य" }, description_localizations: { "hi" => "किसी विशिष्ट उपयोगकर्ता के संदेश हटाएँ" })
      option.string("contains", "Remove messages that contain this text (case sensitive).", required: false, min_length: 1, name_localizations: { "hi" => "रोकना" }, description_localizations: { "hi" => "इस स्ट्रिंग वाले संदेश हटाएँ (केस सेंसिटिव)" })
      option.boolean("reaction", "Remove messages that have reactions.", required: false, name_localizations: { "hi" => "प्रतिक्रिया" }, description_localizations: { "hi" => "प्रतिक्रिया वाले संदेश हटाएँ" })
      option.boolean("embeds", "Remove messages that have embeds.", required: false, name_localizations: { "hi" => "एम्बेड" }, description_localizations: { "hi" => "एम्बेड किए गए संदेश हटाएं" })
      option.string("before", "Remove messages the come before this message ID.", required: false, name_localizations: { "hi" => "पहले" }, description_localizations: { "hi" => "इस संदेश आईडी से पहले आने वाले संदेशों को हटाएँ" })
      option.string("prefix", "Remove messages that start with this text (case sensitive).", required: false, min_length: 1, name_localizations: { "hi" => "उपसर्ग" }, description_localizations: { "hi" => "इस स्ट्रिंग से शुरू होने वाले संदेश हटाएँ (केस सेंसिटिव)" })
      option.string("suffix", "Remove messages that end with this text (case sensitive).", required: false, min_length: 1, name_localizations: { "hi" => "प्रत्यय" }, description_localizations: { "hi" => "इस स्ट्रिंग से समाप्त होने वाले संदेश हटाएँ (केस सेंसिटिव)" })
      option.boolean("robot", "Remove messages from bot accounts (not webhooks).", required: false, name_localizations: { "hi" => "रोबोट" }, description_localizations: { "hi" => "बॉट खातों से संदेश हटाएं (वेबहुक से नहीं)" })
      option.boolean("emoji", "Remove messages that have custom emojis.", required: false, name_localizations: { "hi" => "इमोजी" }, description_localizations: { "hi" => "कस्टम इमोजी वाले संदेश हटाएं" })
      option.string("after", "Remove messages the come after this message ID.", required: false, min_length: 16, max_length: 21, name_localizations: { "hi" => "बाद" }, description_localizations: { "hi" => "इस संदेश आईडी के बाद आने वाले संदेशों को हटाएँ" })
      option.boolean("files", "Remove messages that have attachments.", required: false, name_localizations: { "hi" => "फ़ाइलें" }, description_localizations: { "hi" => "ऐसे संदेश हटाएँ जिनमें अनुलग्नक हों" })
    end
  end

@bot.include! PinArchiver
@bot.include! BoosterPerks
@bot.include! EmojiCommands
@bot.include! AdminCommands
@bot.include! BirthdayCommands
@bot.include! AffectionCommands
@bot.include! ModerationCommands

@bot.run
