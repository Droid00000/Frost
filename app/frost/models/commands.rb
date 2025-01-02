# frozen_string_literal: true

require 'discordrb'

bot = Discordrb::Bot.new(token: ENV.fetch('TOKEN'), intents: 0)

# @!function [Affections] This command is part of a cog that does expressions! 
bot.register_application_command(:hug, 'Hugs another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'गलेमिलना' }, description_localizations: { 'hi' => 'सर्वर मित्र के गले मिलना' }) do |option|
  option.user('target', 'Who do you want to hug?', required: true, name_localizations: { 'hi' => 'इशारालगाना' }, description_localizations: { 'hi' => 'किसको गले मिलना है' })
end

# @!function [Affections] This command is part of a cog that does expressions! 
bot.register_application_command(:poke, 'Pokes another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'बुलाना' }, description_localizations: { 'hi' => 'कोई सर्वर मित्र को बुलाना' }) do |option|
  option.user('target', 'Who do you want to poke?', required: true, name_localizations: { 'hi' => 'इशारालगाना' }, description_localizations: { 'hi' => 'किसको बुलाना है' })
end
# @!function [Affections] This command is part of a cog that does expressions! 
bot.register_application_command(:nom, 'Noms another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'कुतरना' }, description_localizations: { 'hi' => 'किसी अन्य सर्वर सदस्य को काटता है' }) do |option|
  option.user('target', 'Who do you want to nom?', required: true, name_localizations: { 'hi' => 'इशारालगाना' }, description_localizations: { 'hi' => 'आप किसे काटना चाहते हैं?' })
end

# @!function [Affections] This command is part of a cog that does expressions!
bot.register_application_command(:angered, 'Show your anger towards another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'गुस्साकरना' }, description_localizations: { 'hi' => 'कोई सर्वर मित्र पे गुस्सा दिखाना' }) do |option|
  option.user('target', 'Who do you want to show your wrath to?', required: true, name_localizations: { 'hi' => 'इशारालगाना' }, description_localizations: { 'hi' => 'किसपे आपको गुस्सा दिखाना है' })
end

# @!function [Affections] This command is part of a cog that does expressions!
bot.register_application_command(:bonk, 'Bonk another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'टपलीमारना' }, description_localizations: { 'hi' => 'किसी सर्वर मित्र को टपाली मारना' }) do |option|
  option.user('target', 'Who do you want to bonk?', required: true, name_localizations: { 'hi' => 'इशारालगाना' }, description_localizations: { 'hi' => 'किसको टपाली मारना है' })
end

# @!function [Affections] This command is part of a cog that does expressions! 
bot.register_application_command(:punch, 'Punch another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'मुक्का' }, description_localizations: { 'hi' => 'एक सर्वर मित्र को मुक्का मारो' }) do |option|
  option.user('target', 'Who do you want to punch?', required: true, name_localizations: { 'hi' => 'इशारालगाना' }, description_localizations: { 'hi' => 'आप किसे मुक्का मारना चाहते हैं?' })
end

# @!function [Affections] This command is part of a cog that does expressions!
bot.register_application_command(:sleep, 'Tells another server member to go and sleep.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'नींद' }, description_localizations: { 'hi' => 'किसी सर्वर मित्र को बोलो जाके सो जाए' }) do |option|
  option.user('target', 'Who needs to sleep?', required: true, name_localizations: { 'hi' => 'इशारालगाना' }, description_localizations: { 'hi' => 'किसको सोने जाने बोलना है' })
end

# @!function [Emoji Operations] Belongs to a cog that manages emoji related commands!
bot.register_application_command(:emoji, 'View some emoji stats.', contexts: [0], integration_types: [0], name_localizations: { 'hi' => 'इमोजी' }, description_localizations: { 'hi' => 'कुछ इमोजी आँकड़े देखें' }) do |command|
  command.subcommand(:stats, 'Get information about the top emojis here.', name_localizations: { 'hi' => 'आँकड़े' }, description_localizations: { 'hi' => 'शीर्ष इमोजी के बारे में जानकारी यहां प्राप्त करें' })
end

# @!function [General Operations] Belongs to a cog that manages general information!
bot.register_application_command(:help, 'Shows some general information about how to use the bot.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'हेल्प' }, description_localizations: { 'hi' => 'बोट का उपयोग कैसे करना है उसके जानकारी चाहिए।' }) do |option|
end

# @!function [Emoji Operations] Belongs to a cog that manages emoji related commands!
bot.register_application_command(:"Add Emoji(s)", nil, type: :message, contexts: [0], integration_types: [0], default_member_permissions: "1073741824", name_localizations: { 'hi' => 'कई इमोजी जोड़ें' }) do |command|
end

# @!function [Emoji Operations] Belongs to a cog that manages emoji related commands!
bot.register_application_command(:"Add Emojis", nil, type: :message, contexts: [0], integration_types: [0], default_member_permissions: "1073741824", name_localizations: { 'hi' => 'इमोजी जोड़ें' }) do |command|
end

# @!function [General Operations] Belongs to a cog that manages general information!
bot.register_application_command(:coin, 'Flip a coin!', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'मुद्रा' }, description_localizations: { 'hi' => 'एक सिक्का पलटें' }) do |command|
  command.subcommand(:flip, 'Flip a coin!', name_localizations: { 'hi' => 'पलटना' }, description_localizations: { 'hi' => 'एक सिक्का पलटें' })
end

# @!function [Moderation Operations] Belongs to a cog that manages moderation related commands!
bot.register_application_command(:freeze, 'Prevent all members from speaking in the server.', contexts: [0], integration_types: [0], default_member_permissions: "268435456", name_localizations: { 'hi' => 'स्थिर' }, description_localizations: { 'hi' => 'सभी सदस्यों को सर्वर में बोलने से रोकें' }) do |option|
  option.string('duration', 'How long should the server be frozen for?', required: false, min_length: 2, max_length: 1000, name_localizations: { 'hi' => 'लंबाई' }, description_localizations: { 'hi' => 'सर्वर को कितने समय के लिए फ़्रीज़ किया जाना चाहिए' })
  option.string('reason', 'The reason for freezing the server.', required: false, max_length: 1000, name_localizations: { 'hi' => 'क्यू' }, description_localizations: { 'hi' => 'सर्वर लॉक होने का कारण' })
end

# @!function [Moderation Operations] Belongs to a cog that manages moderation related commands!
bot.register_application_command(:unfreeze, 'Remove the lock caused by the freeze command.', contexts: [0], integration_types: [0], default_member_permissions: "268435456", name_localizations: { 'hi' => 'अनफ़्रीज़' }, description_localizations: { 'hi' => 'फ़्रीज़ कमांड का उपयोग करके होने वाले टाइमआउट को अनलॉक करें' }) do |option|
  option.string('reason', 'The reason for un-freezing the server.', required: false, max_length: 1000, name_localizations: { 'hi' => 'वजह' }, description_localizations: { 'hi' => 'सर्वर को अनफ्रीज करने का कारण' })
end

# @!function [Moderation Operations] Belongs to a cog that manages moderation related commands!
bot.register_application_command(:block, 'Stop a member from being able to access this channel.', contexts: [0], integration_types: [0], default_member_permissions: "268435456", name_localizations: { 'hi' => 'ब्लॉक' }, description_localizations: { 'hi' => 'किसी सदस्य को चैनल का उपयोग करने से रोकें।' }) do |option|
  option.user('member', 'Which member do you want to lock out?', required: true, name_localizations: { 'hi' => 'लोग' }, description_localizations: { 'hi' => 'आप किस सदस्य को लॉक आउट करना चाहते हैं' })
  option.boolean('cascade', 'Should this member be blocked from every channel in this server?', required: true, name_localizations: { 'hi' => 'झरना' }, description_localizations: { 'hi' => 'क्या इस सदस्य को इस सर्वर के प्रत्येक चैनल से ब्लॉक कर दिया जाना चाहिए' })
end

# @!function [Moderation Operations] Belongs to a cog that manages moderation related commands!
bot.register_application_command(:mute, 'Stop a member from being able to talk in this server.', contexts: [0], integration_types: [0], default_member_permissions: "1099511627776", name_localizations: { 'hi' => 'मूक' }, description_localizations: { 'hi' => 'किसी सदस्य को इस सर्वर में बात करने से रोकें' }) do |option|
  option.user('member', 'Which member do you want to mute?', required: true, name_localizations: { 'hi' => 'लोग' }, description_localizations: { 'hi' => 'आप किस सदस्य को म्यूट करना चाहते हैं' })
  option.string('duration', 'How long the mute should last. Max 28 days. ', required: true, name_localizations: { 'hi' => 'लंबाई' }, description_localizations: { 'hi' => 'कितनी देर तक मौन रहना चाहिए. अधिकतम अट्ठाईस दिन' })
end

# @!function [Moderation Operations] Belongs to a cog that manages moderation related commands!
bot.register_application_command(:bulk, 'Moderation Commands', contexts: [0], integration_types: [0], name_localizations: { 'hi' => 'थोक' }, description_localizations: { 'hi' => 'मॉडरेशन आदेश' }, default_member_permissions: "36") do |command|
  command.subcommand('ban', 'Ban multiple members at once!', name_localizations: { 'hi' => 'प्रतिबंध' }, description_localizations: { 'hi' => 'एक साथ कई सदस्यों पर प्रतिबंध लगाएं' }) do |option|
    option.string('members', 'Which members do you want to ban?', required: true, name_localizations: { 'hi' => 'लोग' }, description_localizations: { 'hi' => 'आप किन सदस्यों पर प्रतिबंध लगाना चाहते हैं?' })
    option.integer('messages', 'How many days worth of messages (1-7) should be deleted?', required: false, min_value: 0, max_value: 7, name_localizations: { 'hi' => 'संदेशों' }, description_localizations: { 'hi' => 'कितने दिनों के संदेश (1-7) हटाये जाने चाहिए?' })
    option.string('reason', 'The reason for banning these members.', required: false, name_localizations: { 'hi' => 'कारण' }, description_localizations: { 'hi' => 'इन सदस्यों पर प्रतिबंध लगाने का कारण' })
  end
end

# @!function [Moderation Operations] Belongs to a cog that manages moderation related commands!
bot.register_application_command(:change, 'Moderation Commands', contexts: [0], integration_types: [0], name_localizations: { 'hi' => 'अद्यतन' }, description_localizations: { 'hi' => 'मॉडरेशन आदेश' }, default_member_permissions: "201326592") do |command|
  command.subcommand('nickname', "Change a member's nickname!", name_localizations: { 'hi' => 'उपनाम' }, description_localizations: { 'hi' => 'किसी सदस्य का उपनाम बदलें' }) do |option|
    option.user('member', 'Which member needs to have their name changed?', required: true, name_localizations: { 'hi' => 'लोग' }, description_localizations: { 'hi' => 'किस सदस्य को अपना नाम बदलना है' })
    option.string('nickname', "What should this member's new nickname be?", required: true, name_localizations: { 'hi' => 'उपनाम' }, description_localizations: { 'hi' => 'इस सदस्य का नया उपनाम क्या होना चाहिए' })
  end
end

# @!function [Moderation Operations] Belongs to a cog that manages moderation related commands!
bot.register_application_command(:purge, 'Moderation Commands', contexts: [0], integration_types: [0], name_localizations: { 'hi' => 'शुद्ध' }, description_localizations: { 'hi' => 'मॉडरेशन आदेश' }, default_member_permissions: "73760") do |command|
  command.subcommand('messages', "Delete messages in the current channel.", name_localizations: { 'hi' => 'सूचना' }, description_localizations: { 'hi' => 'वर्तमान चैनल में संदेश हटाएँ' }) do |option|
    option.integer('amount', 'How many messages do you want to delete?', required: true, min_value: 1, max_value: 600, name_localizations: { 'hi' => 'रकम' }, description_localizations: { 'hi' => 'आप कितने मैसेज डिलीट करना चाहते हैं' })
  end
end

# @!function [Pin Operations] Belongs to a cog that manages pins in a channel!
bot.register_application_command(:archive, 'Archives pins in a specified channel.', default_member_permissions: "8192", contexts: [0], integration_types: [0], name_localizations: { 'hi' => 'पुरातत्व' }, description_localizations: { 'hi' => 'पुरातत्व पिंस कोई चुनित चैनल मै' }) do |option|
end

# @!function [General Operations] Belongs to a cog that manages general information!
bot.register_application_command(:eval, 'Allows the bot owner to execute code.', default_member_permissions: "0", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'लगाना' }, description_localizations: { 'hi' => 'बोट ऑनर को कोड रन करनेकी इजाजत है' }) do |option|
  option.string('code', 'The code you want to execute.', required: true, name_localizations: { 'hi' => 'कोड' }, description_localizations: { 'hi' => 'कोड जो रन करना है' })
end

# @!function [General Operations] Belongs to a cog that manages general information!
bot.register_application_command(:settings, 'View your server configuration.', default_member_permissions: "32", contexts: [0], integration_types: [0], name_localizations: { 'hi' => 'सेटिंग्स' }, description_localizations: { 'hi' => 'आपना सर्वर कॉन्फिग्रेशन देखो' }) do |option|
end

# @!function [General Operations] Belongs to a cog that manages general information!
bot.register_application_command(:shutdown, 'Safely disconnects the bot from the Gateway.', default_member_permissions: "0", contexts: [0, 1], integration_types: [0, 1], name_localizations: { 'hi' => 'बंधकरो' }, description_localizations: { 'hi' => 'सावधानी से बोट को गेटवे से डिसकनेक्ट करो' }) do |option|
end

# @!function [General Operations] Belongs to a cog that manages general information!
bot.register_application_command(:restart, 'Safely restarts and reconnects the bot to the Gateway.', default_member_permissions: "0", contexts: [0, 1], integration_types: [0, 1], name_localizations: { 'hi' => 'फिरसेकरो' }, description_localizations: { 'hi' => 'सुरक्षित रूप से पुनरारंभ होता है और बॉट को गेटवे से पुनः कनेक्ट करता है' }) do |option|
end

# @!function [Snowball Operations] Belongs to a cog that does snowball fights between members!
bot.register_application_command(:throw, 'Snowball fights', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'फेंको' }, description_localizations: { 'hi' => 'बर्फ का गोला की लड़ीं' }) do |command|
  command.subcommand('snowball', 'Throw a snowball at someone!', name_localizations: { 'hi' => 'बर्फकालोग' }, description_localizations: { 'hi' => 'बर्फ का गोला फेक' }) do |option|
    option.user('member', 'Who do you want to hit with a snowball?', required: true, name_localizations: { 'hi' => 'लोग' }, description_localizations: { 'hi' => 'बर्फ का गोला किसे मारना चाहते हो' })
  end
end

# @!function [Snowball Operations] Belongs to a cog that does snowball fights between members!
bot.register_application_command(:collect, 'Snowball fights', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'जमा' }, description_localizations: { 'hi' => 'बर्फ का गोला की लड़ीं' }) do |command|
  command.subcommand('snowball', 'Collect a snowball!', name_localizations: { 'hi' => 'बर्फकालोग' }, description_localizations: { 'hi' => 'बर्फ का गोला जमा करो' })
end

# @!function [Snowball Operations] Belongs to a cog that does snowball fights between members!
bot.register_application_command(:steal, 'Snowball fights', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'चोरी' }, description_localizations: { 'hi' => 'बर्फ का गोला की लड़ीं' }) do |command|
  command.subcommand('snowball', 'Steal a snowball from someone!', name_localizations: { 'hi' => 'बर्फकालोग' }, description_localizations: { 'hi' => 'बर्फ का लोग किसी से चूरो' }) do |option|
    option.user('member', 'Who do you want to steal snowballs from?', required: true, name_localizations: { 'hi' => 'लोग' }, description_localizations: { 'hi' => 'किस से बर्फ का लोग चोरी करना है' })
    option.integer('amount', 'How many snowballs do you want to steal?', choices: { two: '2', three: '3', four: '4', five: '5' }, required: true, name_localizations: { 'hi' => 'अमाउंट' }, description_localizations: { 'hi' => 'कितने बर्फ के गोले चुराने है' })
  end
end

# @!function [General Operations] Belongs to a cog that manages general information!
bot.register_application_command(:update, 'Contributors', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'अपडेट' }, description_localizations: { 'hi' => 'सहकारी गण' }) do |command|
  command.subcommand('status', "Update the status that's show by the bot.", name_localizations: { 'hi' => 'स्टेटस' }, description_localizations: { 'hi' => 'अपटेड स्टेटस जो बोट दिखा रहा है' }) do |option|
    option.string('description', 'The status that the bot should display.', required: false, name_localizations: { 'hi' => 'डिस्क्रिप्शन' }, description_localizations: { 'hi' => 'स्टेटस जो बोट की दिखाना चाहिए' })
    option.string('type', 'The type of online status that the bot should display.', choices: { online: 'Online', idle: 'Idle', dnd: 'DND' }, required: false, name_localizations: { 'hi' => 'प्रजाति' }, description_localizations: { 'hi' => 'कौनसी प्रजाति का स्टेटस बोट की दिखाना चाहिए' })
  end
end

# @!function [Pin Operations] Belongs to a cog that manages pins in a channel!
bot.register_application_command(:pin, 'Pin archive', default_member_permissions: "16", contexts: [0], integration_types: [0], name_localizations: { 'hi' => 'पिन' }, description_localizations: { 'hi' => 'की पुरातत्' }) do |command|
  command.subcommand_group(:archiver, 'Pin Archival!', name_localizations: { 'hi' => 'संग्रहकर्ता' }, description_localizations: { 'hi' => 'की पुरातत्व' }) do |group|
    group.subcommand(:setup, 'Setup the pin-archiver functionality.', name_localizations: { 'hi' => 'बंदोबस्त' }, description_localizations: { 'hi' => 'पिन की पुरातत्व की कंडीशन' }) do |option|
      option.channel('channel', 'Which channel should archived pins be sent to?', required: true, types: [:text], name_localizations: { 'hi' => 'प्रवाह' }, description_localizations: { 'hi' => 'किधर पुरातात्विक पिंस जाने चाहिए' })
    end

    group.subcommand(:disable, 'disable the pin-archiver functionality.', name_localizations: { 'hi' => 'बंदकरने' }, description_localizations: { 'hi' => 'पिन पुरातत्व कंडीशन को बंद करो' }) do |option|
    end
  end
end

# @!function [Event Operations] Belongs to a cog that manages custom roles!
bot.register_application_command(:events, 'Event roles setup', default_member_permissions: "268435456", contexts: [0], integration_types: [0], name_localizations: { 'hi' => 'घटनाएँ' }, description_localizations: { 'hi' => 'इवेंट रोल्स सेटअप करें' }) do |command|
  command.subcommand_group(:role, 'Event roles!', name_localizations: { 'hi' => 'भूमिका' }, description_localizations: { 'hi' => 'इवेंट रोल्स के लिए सेटअप करें' }) do |group|
    group.subcommand(:setup, 'Setup the event roles functionality.', name_localizations: { 'hi' => 'व्यवस्था' }, description_localizations: { 'hi' => 'इवेंट रोल्स कार्यक्षमता सेटअप करें' }) do |option|
      option.role('role', 'Which role should be modifiable by its users?', required: true, name_localizations: { 'hi' => 'रोल' }, description_localizations: { 'hi' => 'कौन सा रोल उपयोगकर्ताओं द्वारा संपादित किया जा सकता है' })
    end

    group.subcommand(:disable, 'Disable the event roles functionality.', name_localizations: { 'hi' => 'असमर्थ' }, description_localizations: { 'hi' => 'इवेंट रोल्स कार्यक्षमता को अक्षम करें' }) do |option|
    end
  end
end

# @!function [Event Operations] Belongs to a cog that manages custom roles!
bot.register_application_command(:event, 'Event roles', contexts: [0], integration_types: [0], name_localizations: { 'hi' => 'इवेंट' }, description_localizations: { 'hi' => 'इवेंट रोल्स' }) do |command|
  command.subcommand_group(:roles, 'Event roles!', name_localizations: { 'hi' => 'रोल्स' }, description_localizations: { 'hi' => 'इवेंट रोल्स' }) do |group|
    group.subcommand(:edit, 'Edit your event role.', name_localizations: { 'hi' => 'परिवर्तन' }, description_localizations: { 'hi' => 'अपने इवेंट रोल को संपादित करें' }) do |option|
      option.role('role', 'Which role do you want to modify?', required: true, name_localizations: { 'hi' => 'रोल' }, description_localizations: { 'hi' => 'आप कौन सा रोल संपादित करना चाहते हैं' })
      option.string('name', 'Provide a name for your role.', required: false, max_length: 100, name_localizations: { 'hi' => 'नाम' }, description_localizations: { 'hi' => 'अपने रोल के लिए एक नाम दें' })
      option.string('color', 'Provide a HEX color for your role.', required: false, min_length: 6, max_length: 7, name_localizations: { 'hi' => 'रंग' }, description_localizations: { 'hi' => 'अपने रोल के लिए एक HEX रंग दें' })
      option.string('icon', 'Provide an emoji to serve as your role icon.', required: false, name_localizations: { 'hi' => 'आइकन' }, description_localizations: { 'hi' => 'अपने रोल आइकन के रूप में एक इमोजी दें' })
    end
  end
end

# @!function [Music Operations] Belongs to a cog that can stream songs!
bot.register_application_command(:music, 'Connect and play songs!.', contexts: [0], integration_types: [0], name_localizations: { 'hi' => 'संगीत' }, description_localizations: { 'hi' => 'कनेक्ट करें और गाने चलाएं' }) do |command|
  command.subcommand(:disconnect, 'Disconnect from a voice channel.', name_localizations: { 'hi' => 'छुट्टी' }, description_localizations: { 'hi' => 'वॉइस चैनल से डिस्कनेक्ट करें' })
  command.subcommand(:shuffle, 'Shuffle the tracks in the queue.', name_localizations: { 'hi' => 'मिश्रण' }, description_localizations: { 'hi' => 'कतार में पटरियों को फेरें' })
  command.subcommand(:current, "View the track that's currently playing.", name_localizations: { 'hi' => 'मौजूदा' }, description_localizations: { 'hi' => 'वह ट्रैक देखें जो वर्तमान में चल रहा है' })
  command.subcommand(:resume, 'Continue playback ater pausing.', name_localizations: { 'hi' => 'फिरशुरूकरना' }, description_localizations: { 'hi' => 'रुकने के बाद प्लेबैक जारी रखें' })
  command.subcommand(:pause, 'Stop playing the current song.', name_localizations: { 'hi' => 'रुकना' }, description_localizations: { 'hi' => 'वर्तमान गाना बजाना बंद करें' })
  command.subcommand(:queue, 'View the tracks that are in the queue.', name_localizations: { 'hi' => 'कतार' }, description_localizations: { 'hi' => 'वे ट्रैक देखें जो कतार में हैं' })
  command.subcommand(:clear, 'Clear the queue for this server.', name_localizations: { 'hi' => 'स्पष्ट' }, description_localizations: { 'hi' => 'इस सर्वर के लिए कतार साफ़ करें' })
  command.subcommand(:back, 'Play the previous track.', name_localizations: { 'hi' => 'पीछे' }, description_localizations: { 'hi' => 'पिछला ट्रैक चलाएँ' })
  command.subcommand(:next, 'Play the next track.', name_localizations: { 'hi' => 'अगला' }, description_localizations: { 'hi' => 'अगला ट्रैक चलाएँ' })

  command.subcommand(:play, 'Play audio from a URL or a song name.', name_localizations: { 'hi' => 'नाटक' }, description_localizations: { 'hi' => 'किसी यूआरएल या गाने के नाम से ऑडियो चलाएं' }) do |option|
    option.string(:song, 'Spotify, Apple Music, YouTube URL, or a song name.', required: true, min_length: 2, name_localizations: { 'hi' => 'गाना' }, description_localizations: { 'hi' => 'एक गीत का लिंक' })
  end

  command.subcommand(:volume, 'Adjust the volume of the player.', name_localizations: { 'hi' => 'आयतन' }, description_localizations: { 'hi' => 'प्लेयर का वॉल्यूम समायोजित करें' }) do |option|
    option.integer(:volume, 'Number between 1 and 200 to set the volume to.', required: true, min_value: 1, max_value: 200, name_localizations: { 'hi' => 'आयतन' }, description_localizations: { "hi" => "वॉल्यूम सेट करने के लिए 1 और 1,000 के बीच की संख्या।" } )
  end
end

# @!function [General Operations] Belongs to a cog that manages general information!
bot.register_application_command(:next, 'Manga Chapter!', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'अगला' }, description_localizations: { 'hi' => 'मंगा अध्याय' }) do |command|
  command.subcommand_group(:chapter, 'Comics!', name_localizations: { 'hi' => 'प्रकरण' }, description_localizations: { 'hi' => 'कॉमिक्स' }) do |group|
    group.subcommand(:when, 'When is the next chapter coming out?', name_localizations: { 'hi' => 'कब' }, description_localizations: { 'hi' => 'अगला अध्याय कब आ रहा है' }) do |option|
    end
  end
end

# @!function [Booster Operations] Belongs to a cog that manages booster roles!
bot.register_application_command(:booster, 'Booster perks', contexts: [0], integration_types: [0]) do |command|
  command.subcommand_group(:role, 'Booster roles!') do |group|
    group.subcommand('claim', 'Claim your custom booster role!') do |option|
      option.string('name', 'Provide a name for your role.', required: true, max_length: 100)
      option.string('color', 'Provide a HEX color for your role.', required: true, min_length: 6, max_length: 7)
      option.string('icon', 'Provide an emoji to serve as your role icon.', required: false)
    end

    group.subcommand('edit', 'Edit your custom booster role!') do |option|
      option.string('name', 'Provide a name for your role.', required: false, max_length: 100)
      option.string('color', 'Provide a HEX color for your role.', required: false, min_length: 6, max_length: 7)
      option.string('icon', 'Provide an emoji to serve as your role icon.', required: false)
    end

    group.subcommand('delete', 'Delete your custom booster role.')
  end

  command.subcommand_group(:admin, 'Booster admin!') do |group|
    group.subcommand('add', "Manually add a 'booster' to the database.") do |option|
      option.user('user', 'The user to add to the database.', required: true)
      option.role('role', 'The role to add to the database.', required: true)
    end

    group.subcommand('delete', 'Manually remove a user from the database!') do |option|
      option.user('user', 'The user to remove from the database.', required: true)
    end

    group.subcommand('ban', 'Ban a user from using the booster perks functionality.') do |option|
      option.user('user', 'The user to ban.', required: true)
    end

    group.subcommand('unban', 'Unban a user from using the booster perks functionality.') do |option|
      option.user('user', 'The user to unban.', required: true)
    end

    group.subcommand('setup', 'Setup the booster perks functionality.') do |option|
      option.role('role', 'Which role should all custom booster roles be placed above?', required: true)
    end

    group.subcommand('disable', 'Disable the booster perks functionality.')
  end
end
