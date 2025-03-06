# frozen_string_literal: true

require "discordrb"

bot = Discordrb::Bot.new(token: ENV.fetch("TOKEN"), intents: :none)

# @!function [General Operations] Belongs to a module that manages general information.
bot.register_application_command(:help, "Open the bot's help menu.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "हेल्प" }, description_localizations: { "hi" => "बोट का उपयोग कैसे करना है उसके जानकारी चाहिए।" })

# @!function [Emoji Operations] Belongs to a module that manages emoji related commands.
bot.register_application_command(:"Add Emoji(s)", nil, type: :message, contexts: [0], integration_types: [0], default_member_permissions: "1073741824", name_localizations: { "hi" => "कई इमोजी जोड़ें" })

# @!function [Emoji Operations] Belongs to a module that manages emoji related commands.
bot.register_application_command(:"Add Emojis", nil, type: :message, contexts: [0], integration_types: [0], default_member_permissions: "1073741824", name_localizations: { "hi" => "इमोजी जोड़ें" })

# @!function [Pin Operations] Belongs to a module that manages pins in a channel.
bot.register_application_command(:archive, "Archives the pinned messages in the current channel.", default_member_permissions: "8192", contexts: [0], integration_types: [0], name_localizations: { "hi" => "पुरातत्व" }, description_localizations: { "hi" => "पुरातत्व पिंस कोई चुनित चैनल मै" })

# @!function [General Operations] Belongs to a module that manages general information.
bot.register_application_command(:settings, "View your server configuration.", default_member_permissions: "268443648", contexts: [0], integration_types: [0], name_localizations: { "hi" => "सेटिंग्स" }, description_localizations: { "hi" => "आपना सर्वर कॉन्फिग्रेशन देखो" })

# @!function [General Operations] Belongs to a module that manages general information.
bot.register_application_command(:shutdown, "Safely disconnects the bot from Discord.", default_member_permissions: "0", contexts: [0, 1], integration_types: [0, 1], name_localizations: { "hi" => "बंधकरो" }, description_localizations: { "hi" => "सावधानी से बोट को गेटवे से डिसकनेक्ट करो" })

# @!function [General Operations] Belongs to a module that manages general information.
bot.register_application_command(:restart, "Safely restarts the bot.", default_member_permissions: "0", contexts: [0, 1], integration_types: [0, 1], name_localizations: { "hi" => "फिरसेकरो" }, description_localizations: { "hi" => "सुरक्षित रूप से पुनरारंभ होता है और बॉट को गेटवे से पुनः कनेक्ट करता है" })

# @!function [Affections] This command is part of a module that does expressions.
bot.register_application_command(:hug, "Hugs another server member.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "गलेमिलना" }, description_localizations: { "hi" => "सर्वर मित्र के गले मिलना" }) do |option|
  option.user("target", "Who do you want to hug?", required: true, name_localizations: { "hi" => "इशारालगाना" }, description_localizations: { "hi" => "किसको गले मिलना है" })
end

# @!function [Affections] This command is part of a module that does expressions.
bot.register_application_command(:poke, "Pokes another server member.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "बुलाना" }, description_localizations: { "hi" => "कोई सर्वर मित्र को बुलाना" }) do |option|
  option.user("target", "Who do you want to poke?", required: true, name_localizations: { "hi" => "इशारालगाना" }, description_localizations: { "hi" => "किसको बुलाना है" })
end
# @!function [Affections] This command is part of a module that does expressions.
bot.register_application_command(:nom, "Noms another server member.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "कुतरना" }, description_localizations: { "hi" => "किसी अन्य सर्वर सदस्य को काटता है" }) do |option|
  option.user("target", "Who do you want to nom?", required: true, name_localizations: { "hi" => "इशारालगाना" }, description_localizations: { "hi" => "आप किसे काटना चाहते हैं?" })
end

# @!function [Affections] This command is part of a module that does expressions.
bot.register_application_command(:angered, "Show your anger towards another server member.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "गुस्साकरना" }, description_localizations: { "hi" => "कोई सर्वर मित्र पे गुस्सा दिखाना" }) do |option|
  option.user("target", "Who are you mad at?", required: true, name_localizations: { "hi" => "इशारालगाना" }, description_localizations: { "hi" => "किसपे आपको गुस्सा दिखाना है" })
end

# @!function [Affections] This command is part of a module that does expressions.
bot.register_application_command(:bonk, "Bonk another server member.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "टपलीमारना" }, description_localizations: { "hi" => "किसी सर्वर मित्र को टपाली मारना" }) do |option|
  option.user("target", "Who do you want to bonk?", required: true, name_localizations: { "hi" => "इशारालगाना" }, description_localizations: { "hi" => "किसको टपाली मारना है" })
end

# @!function [Affections] This command is part of a module that does expressions.
bot.register_application_command(:punch, "Punch another server member.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "मुक्का" }, description_localizations: { "hi" => "एक सर्वर मित्र को मुक्का मारो" }) do |option|
  option.user("target", "Who do you want to punch?", required: true, name_localizations: { "hi" => "इशारालगाना" }, description_localizations: { "hi" => "आप किसे मुक्का मारना चाहते हैं?" })
end

# @!function [Affections] This command is part of a module that does expressions.
bot.register_application_command(:sleep, "Tells another server member to go and sleep.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "नींद" }, description_localizations: { "hi" => "किसी सर्वर मित्र को बोलो जाके सो जाए" }) do |option|
  option.user("target", "Who needs to go to sleep?", required: true, name_localizations: { "hi" => "इशारालगाना" }, description_localizations: { "hi" => "किसको सोने जाने बोलना है" })
end

# @!function [Emoji Operations] Belongs to a module that manages emoji related commands.
bot.register_application_command(:top, "View some emoji stats.", contexts: [0], integration_types: [0], name_localizations: { "hi" => "इमोजी" }, description_localizations: { "hi" => "कुछ इमोजी आँकड़े देखें" }) do |command|
  command.subcommand(:emojis, "View the most used emojis in this server.", name_localizations: { "hi" => "आँकड़े" }, description_localizations: { "hi" => "शीर्ष इमोजी के बारे में जानकारी यहां प्राप्त करें" })
end

# @!function [Affections] This command is part of a module that manages general information.
bot.register_application_command(:time, "View the current time.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "समय" }, description_localizations: { "hi" => "वर्तमान समय देखें" }) do |option|
  option.string("timezone", "Which timezone do you want to view the time for?", required: true, autocomplete: true, name_localizations: { "hi" => "समयक्षेत्र" }, description_localizations: { "hi" => "आप किस समयक्षेत्र का समय देखना चाहते हैं" })
end

# @!function [Emoji Operations] Belongs to a module that manages emoji related commands.
bot.register_application_command(:drain, "View some emoji stats.", contexts: [1], integration_types: [1], name_localizations: { "hi" => "निकास" }, description_localizations: { "hi" => "कुछ इमोजी आँकड़े देखें" }) do |command|
  command.subcommand(:emojis, "Add all the cached emojis to the database.", name_localizations: { "hi" => "इमोजी" }, description_localizations: { "hi" => "सभी कैश्ड इमोजी को डेटाबेस में हटा देता है" })
end

# @!function [General Operations] Belongs to a module that manages general information.
bot.register_application_command(:coin, "Flip a coin!", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "मुद्रा" }, description_localizations: { "hi" => "एक सिक्का पलटें" }) do |command|
  command.subcommand(:flip, "Flip a coin.", name_localizations: { "hi" => "पलटना" }, description_localizations: { "hi" => "एक सिक्का पलटें" })
end

# @!function [Moderation Operations] Belongs to a module that manages moderation related commands.
bot.register_application_command(:block, "Stop a member from being able to access this channel.", contexts: [0], integration_types: [0], default_member_permissions: "268435456", name_localizations: { "hi" => "ब्लॉक" }, description_localizations: { "hi" => "किसी सदस्य को चैनल का उपयोग करने से रोकें।" }) do |option|
  option.user("member", "Which member do you want to lock out?", required: true, name_localizations: { "hi" => "लोग" }, description_localizations: { "hi" => "आप किस सदस्य को लॉक आउट करना चाहते हैं" })
  option.boolean("cascade", "Should this member be blocked from every channel in this server?", required: true, name_localizations: { "hi" => "झरना" }, description_localizations: { "hi" => "क्या इस सदस्य को इस सर्वर के प्रत्येक चैनल से ब्लॉक कर दिया जाना चाहिए" })
end

# @!function [Moderation Operations] Belongs to a module that manages moderation related commands.
bot.register_application_command(:change, "Moderation Commands", contexts: [0], integration_types: [0], name_localizations: { "hi" => "अद्यतन" }, description_localizations: { "hi" => "मॉडरेशन आदेश" }, default_member_permissions: "201326592") do |command|
  command.subcommand("nickname", "Modify a member's nickname.", name_localizations: { "hi" => "उपनाम" }, description_localizations: { "hi" => "किसी सदस्य का उपनाम बदलें" }) do |option|
    option.user("member", "Which member needs to have their name changed?", required: true, name_localizations: { "hi" => "लोग" }, description_localizations: { "hi" => "किस सदस्य को अपना नाम बदलना है" })
    option.string("nickname", "What should this member's new nickname be?", required: true, name_localizations: { "hi" => "उपनाम" }, description_localizations: { "hi" => "इस सदस्य का नया उपनाम क्या होना चाहिए" })
  end
end

# @!function [General Operations] Belongs to a module that manages general information.
bot.register_application_command(:evaluate, "Remotely execute and evaluate code.", default_member_permissions: "0", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "लगाना" }, description_localizations: { "hi" => "बोट ऑनर को कोड रन करनेकी इजाजत है" }) do |option|
  option.string("code", "The code you want to execute.", required: true, name_localizations: { "hi" => "कोड" }, description_localizations: { "hi" => "कोड जो रन करना है" })
end

# @!function [Snowball Operations] Belongs to a module that does snowball fights between members.
bot.register_application_command(:throw, "Snowball fights", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "फेंको" }, description_localizations: { "hi" => "बर्फ का गोला की लड़ीं" }) do |command|
  command.subcommand("snowball", "Throw a snowball at someone.", name_localizations: { "hi" => "बर्फकालोग" }, description_localizations: { "hi" => "बर्फ का गोला फेक" }) do |option|
    option.user("member", "Who do you want to hit with a snowball?", required: true, name_localizations: { "hi" => "लोग" }, description_localizations: { "hi" => "बर्फ का गोला किसे मारना चाहते हो" })
  end
end

# @!function [Snowball Operations] Belongs to a module that does snowball fights between members.
bot.register_application_command(:collect, "Snowball fights", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "जमा" }, description_localizations: { "hi" => "बर्फ का गोला की लड़ीं" }) do |command|
  command.subcommand("snowball", "Collect a snowball.", name_localizations: { "hi" => "बर्फकालोग" }, description_localizations: { "hi" => "बर्फ का गोला जमा करो" })
end

# @!function [Moderation Operations] Belongs to a module that manages moderation related commands.
bot.register_application_command(:gatekeeper, "Moderation Commands", contexts: [0], integration_types: [0], name_localizations: { "hi" => "द्वारपाल" }, description_localizations: { "hi" => "मॉडरेशन आदेश" }, default_member_permissions: "32") do |command|
  command.subcommand("disable", "Allow new members to join this server.", name_localizations: { "hi" => "अपंग" }, description_localizations: { "hi" => "नये सदस्यों को इस सर्वर से जुड़ने की अनुमति दें" })

  command.subcommand("enable", "Prevent new members from joining this server.", name_localizations: { "hi" => "सक्षम" }, description_localizations: { "hi" => "नये सदस्यों को इस सर्वर से जुड़ने से रोकें" }) do |option|
    option.string("duration", "When should invites be enabled again? ", required: false, min_length: 1, max_length: 10, name_localizations: { "hi" => "अवधि" }, description_localizations: { "hi" => "आमंत्रण सुविधा को पुनः कब सक्षम किया जाना चाहिए" })
  end
end

# @!function [Snowball Operations] Belongs to a module that does snowball fights between members.
bot.register_application_command(:steal, "Snowball fights", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "चोरी" }, description_localizations: { "hi" => "बर्फ का गोला की लड़ीं" }) do |command|
  command.subcommand("snowball", "Steal a snowball from someone.", name_localizations: { "hi" => "बर्फकालोग" }, description_localizations: { "hi" => "बर्फ का लोग किसी से चूरो" }) do |option|
    option.user("member", "Who do you want to steal snowballs from?", required: true, name_localizations: { "hi" => "लोग" }, description_localizations: { "hi" => "किस से बर्फ का लोग चोरी करना है" })
    option.integer("amount", "How many snowballs do you want to steal?", choices: { two: "2", three: "3", four: "4", five: "5" }, required: true, name_localizations: { "hi" => "अमाउंट" }, description_localizations: { "hi" => "कितने बर्फ के गोले चुराने है" })
  end
end

# @!function [General Operations] Belongs to a module that manages general information.
bot.register_application_command(:update, "Contributors", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "अपडेट" }, description_localizations: { "hi" => "सहकारी गण" }) do |command|
  command.subcommand("status", "Update the status show by the bot.", name_localizations: { "hi" => "स्टेटस" }, description_localizations: { "hi" => "अपटेड स्टेटस जो बोट दिखा रहा है" }) do |option|
    option.string("description", "The status that the bot should display.", required: false, name_localizations: { "hi" => "डिस्क्रिप्शन" }, description_localizations: { "hi" => "स्टेटस जो बोट की दिखाना चाहिए" })
    option.string("type", "The type of online status that the bot should display.", choices: { online: "Online", idle: "Idle", dnd: "DND" }, required: false, name_localizations: { "hi" => "प्रजाति" }, description_localizations: { "hi" => "कौनसी प्रजाति का स्टेटस बोट की दिखाना चाहिए" })
  end
end

# @!function [General Operations] Belongs to a module that manages general information.
bot.register_application_command(:next, "Manga Chapter!", server_id: ENV.fetch("GUILD"), contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { "hi" => "अगला" }, description_localizations: { "hi" => "मंगा अध्याय" }) do |command|
  command.subcommand_group(:chapter, "Comics!", name_localizations: { "hi" => "प्रकरण" }, description_localizations: { "hi" => "कॉमिक्स" }) do |group|
    group.subcommand(:when, "View the release date of the next chapter.", name_localizations: { "hi" => "कब" }, description_localizations: { "hi" => "अगला अध्याय कब आ रहा है" })
  end
end

# @!function [Pin Operations] Belongs to a module that manages pins in a channel.
bot.register_application_command(:pin, "Pin archive", default_member_permissions: "16", contexts: [0], integration_types: [0], name_localizations: { "hi" => "पिन" }, description_localizations: { "hi" => "की पुरातत्" }) do |command|
  command.subcommand_group(:archiver, "Pin Archival!", name_localizations: { "hi" => "संग्रहकर्ता" }, description_localizations: { "hi" => "की पुरातत्व" }) do |group|
    group.subcommand(:setup, "Setup the pin archiver functionality.", name_localizations: { "hi" => "बंदोबस्त" }, description_localizations: { "hi" => "पिन की पुरातत्व की कंडीशन" }) do |option|
      option.channel("channel", "Which channel should archived pins be sent to?", required: true, types: [:text], name_localizations: { "hi" => "प्रवाह" }, description_localizations: { "hi" => "किधर पुरातात्विक पिंस जाने चाहिए" })
    end

    group.subcommand(:disable, "disable the pin archiver functionality.", name_localizations: { "hi" => "बंदकरने" }, description_localizations: { "hi" => "पिन पुरातत्व कंडीशन को बंद करो" })
  end
end

# @!function [Moderation Operations] Belongs to a module that manages moderation related commands.
bot.register_application_command(:purge, "Moderation Commands", contexts: [0], integration_types: [0], name_localizations: { "hi" => "शुद्ध" }, description_localizations: { "hi" => "मॉडरेशन आदेश" }, default_member_permissions: "10256") do |command|
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

# @!function [Event Operations] Belongs to a module that manages custom roles.
bot.register_application_command(:event, "Event roles", contexts: [0], integration_types: [0], name_localizations: { "hi" => "इवेंट" }, description_localizations: { "hi" => "इवेंट रोल्स" }) do |command|
  command.subcommand_group(:roles, "Event roles!", name_localizations: { "hi" => "रोल्स" }, description_localizations: { "hi" => "इवेंट रोल्स" }) do |group|
    group.subcommand(:edit, "Edit your event role.", name_localizations: { "hi" => "परिवर्तन" }, description_localizations: { "hi" => "अपने इवेंट रोल को संपादित करें" }) do |option|
      option.role("role", "Which role do you want to modify?", required: true, name_localizations: { "hi" => "रोल" }, description_localizations: { "hi" => "आप कौन सा रोल संपादित करना चाहते हैं" })
      option.string("name", "Provide a name for your role.", required: false, max_length: 100, name_localizations: { "hi" => "नाम" }, description_localizations: { "hi" => "अपने रोल के लिए एक नाम दें" })
      option.string("color", "Provide a HEX color for your role.", required: false, min_length: 3, max_length: 16, name_localizations: { "hi" => "रंग" }, description_localizations: { "hi" => "अपने रोल के लिए एक HEX रंग दें" })
      option.string("icon", "Provide an emoji for your role icon.", required: false, name_localizations: { "hi" => "आइकन" }, description_localizations: { "hi" => "अपने रोल आइकन के रूप में एक इमोजी दें" })
    end

    group.subcommand(:add, "Setup the event roles functionality.", name_localizations: { "hi" => "व्यवस्था" }, description_localizations: { "hi" => "इवेंट रोल्स कार्यक्षमता सेटअप करें" }) do |option|
      option.role("role", "Which role should be modifiable by its users?", required: true, name_localizations: { "hi" => "रोल" }, description_localizations: { "hi" => "कौन सा रोल उपयोगकर्ताओं द्वारा संपादित किया जा सकता है" })
      option.boolean("icon", "Should external emojis be allowed as role icons?", required: true, name_localizations: { "hi" => "आइकन" }, description_localizations: { "hi" => "क्या बाह्य इमोजी को भूमिका चिह्न के रूप में अनुमति दी जानी चाहिए" })
    end

    group.subcommand(:remove, "Remove event roles functionality from a role.", name_localizations: { "hi" => "निकालना" }, description_localizations: { "hi" => "किसी भूमिका से ईवेंट भूमिका कार्यक्षमता हटाएँ" }) do |option|
      option.role("role", "Which role needs to be removed?", required: true, name_localizations: { "hi" => "रोल" }, description_localizations: { "hi" => "किस भूमिका को हटाने की जरूरत है" })
    end

    group.subcommand(:disable, "Disable the event roles functionality.", name_localizations: { "hi" => "असमर्थ" }, description_localizations: { "hi" => "इवेंट रोल्स कार्यक्षमता को अक्षम करें" })
  end
end

# @!function [Birthday Operations] Belongs to a module that manages birthday roles.
bot.register_application_command(:birthday, "birthday roles", contexts: [0], integration_types: [0]) do |command|
  command.subcommand("set", "Set your date of birth.") do |option|
    option.integer("day", "The day you were born on.", required: false, min_value: 1, max_value: 31)
    option.string("month", "The month you were born in.", required: false, choices: { January: 1, February: 2, March: 3, April: 4, May: 5, June: 6, July: 7, August: 8, September: 9, October: 10, November: 11, December: 12 })
    option.string("timezone", "Your timezone identifier, for example, Asia/Baku.", required: true, autocomplete: true, min_length: 5, max_length: 35)
  end

  command.subcommand("edit", "Edit your date of birth or timezone.") do |option|
    option.integer("day", "The day you were born on.", required: false, min_value: 1, max_value: 31)
    option.string("month", "The month you were born in.", required: false, choices: { January: 1, February: 2, March: 3, April: 4, May: 5, June: 6, July: 7, August: 8, September: 9, October: 10, November: 11, December: 12 })
    option.string("timezone", "Your timezone identifier (e.g., Asia/Baku).", required: false, autocomplete: true, min_length: 5, max_length: 35)
  end

  command.subcommand("delete", "Remove your date of birth from the bot.")

  command.subcommand_group(:admin, "Birthday admin!") do |group|
    group.subcommand("setup", "Setup the birthday roles functionality.") do |option|
      option.role("role", "Which role should members be given on their birthday?", required: false)
      option.channel("channel", "Which channel should birthday announcements be sent to?", types: [:text], required: false)
    end

    group.subcommand("disable", "Disable the birthday roles functionality.") do |option|
      option.boolean("prune", "Should all birthdays be removed from the database?", required: true)
    end
  end
end

# @!function [Booster Operations] Belongs to a module that manages booster roles.
bot.register_application_command(:booster, "Booster perks", contexts: [0], integration_types: [0]) do |command|
  command.subcommand_group(:role, "Booster roles!") do |group|
    group.subcommand("claim", "Claim your custom booster role.") do |option|
      option.string("name", "Provide a name for your role.", required: true, max_length: 100)
      option.string("color", "Provide a HEX color for your role.", required: true, min_length: 3, max_length: 16)
      option.string("icon", "Provide an emoji for your role icon.", required: false)
    end

    group.subcommand("edit", "Edit your custom booster role.") do |option|
      option.string("name", "Provide a name for your role.", required: false, max_length: 100)
      option.string("color", "Provide a HEX color for your role.", required: false, min_length: 3, max_length: 16)
      option.string("icon", "Provide an emoji for your role icon.", required: false)
    end

    group.subcommand("delete", "Delete your custom booster role.")
  end

  command.subcommand_group(:admin, "Booster admin!") do |group|
    group.subcommand("add", "Manually add a \"booster\" to this server.") do |option|
      option.user("member", "The user to add to the database.", required: true)
      option.role("role", "The role to add to the database.", required: true)
    end

    group.subcommand("delete", 'Manually remove a "booster" from this server.') do |option|
      option.user("member", "The user to remove from the database.", required: true)
    end

    group.subcommand("ban", "Ban a user from using the booster perks functionality.") do |option|
      option.user("member", "The user to ban.", required: true)
      option.boolean("prune", "Should this member's custom role be deleted?", required: true)
    end

    group.subcommand("unban", "Unban a user from using the booster perks functionality.") do |option|
      option.user("member", "The user to unban.", required: true)
    end

    group.subcommand("disable", "Disable the booster perks functionality.") do |option|
      option.boolean("prune", "If all roles should be removed from the database.", required: true)
    end

    group.subcommand("setup", "Setup the booster perks functionality.") do |option|
      option.role("role", "Which role should all custom booster roles be placed above?", required: false)
      option.boolean("icon", "Should external emojis be allowed as role icons?", required: false)
      option.integer("mode", "What mode should the booster perks functionality use?", required: false, choices: { Queue: 0, "Self-Service": 1 } )
    end
  end
end
