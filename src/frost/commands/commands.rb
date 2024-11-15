# frozen_string_literal: true

$LOAD_PATH.unshift '../model'

require 'discordrb'
require 'constants'

bot = Discordrb::Bot.new(token: CONFIG['Discord']['TOKEN'], intents: 0)

bot.register_application_command(:hug, 'Hugs another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'गले मिलना' }, description_localizations: { 'hi' => 'सर्वर मित्र के गले मिलना' }) do |option|
  option.user('target', 'Who do you want to hug?', required: true, name_localizations: { 'hi' => 'इशारा लगाना' }, description_localizations: { 'hi' => 'किसको गले मिलना है' })
end

bot.register_application_command(:poke, 'Pokes another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'बुलाना' }, description_localizations: { 'hi' => 'कोई सर्वर मित्र को बुलाना' }) do |option|
  option.user('target', 'Who do you want to poke?', required: true, name_localizations: { 'hi' => 'इशारा लगाना' }, description_localizations: { 'hi' => 'किसको बुलाना है' })
end

bot.register_application_command(:nom, 'Noms another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
  option.user('target', 'Who do you want to nom?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
end

bot.register_application_command(:angered, 'Show your anger towards another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'गुस्सा करना' }, description_localizations: { 'hi' => 'कोई सर्वर मित्र पे गुस्सा दिखाना' }) do |option|
  option.user('target', 'Who do you want to show your wrath to?', required: true, name_localizations: { 'hi' => 'इशारा लगाना' }, description_localizations: { 'hi' => 'किसपे आपको गुस्सा दिखाना है' })
end

bot.register_application_command(:bonk, 'Bonk another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'टपली मारना' }, description_localizations: { 'hi' => 'किसी सर्वर मित्र को टपाली मारना' }) do |option|
  option.user('target', 'Who do you want to bonk?', required: true, name_localizations: { 'hi' => 'इशारा लगाना' }, description_localizations: { 'hi' => 'किसको टपाली मारना है' })
end

bot.register_application_command(:punch, 'Punch another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'मुक्का' }, description_localizations: { 'hi' => 'एक सर्वर मित्र को मुक्का मारो' }) do |option|
  option.user('target', 'Who do you want to punch?', required: true, name_localizations: { 'hi' => 'इशारा लगाना' }, description_localizations: { 'hi' => 'आप किसे मुक्का मारना चाहते हैं?' })
end

bot.register_application_command(:sleep, 'Tells another server member to go and sleep.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'नींद' }, description_localizations: { 'hi' => 'किसी सर्वर मित्र को बोलो जाके सो जाए' }) do |option|
  option.user('target', 'Who needs to sleep?', required: true, name_localizations: { 'hi' => 'इशारा लगाना' }, description_localizations: { 'hi' => 'किसको सोने जाने बोलना है' })
end

bot.register_application_command(:help, 'Shows some general information about how to use the bot.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'हेल्प' }, description_localizations: { 'hi' => 'बोट का उपयोग कैसे करना है उसके जानकारी चाहिए।' }) do |option|
end

bot.register_application_command(:about, 'Shows some general information about the bot.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'जानकारी' }, description_localizations: { 'hi' => 'बोट का उपयोग कैसे करना है उसके जानकारी चाहिए।' }) do |option|
end

bot.register_application_command(:"add emoji(s)", nil, type: :message, contexts: [0], integration_types: [0], name_localizations: { 'hi' => 'कई इमोजी जोड़ें' }) do |command|
end

bot.register_application_command(:"add emojis", nil, type: :message, contexts: [0], integration_types: [0], name_localizations: { 'hi' => 'इमोजी जोड़ें' }) do |command|
end

bot.register_application_command(:freeze, 'Prevent all members from speaking in the server.', contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
  option.string('duration', 'How long should the server be frozen for?', required: false, min_length: 2, max_length: 1000, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
  option.string('reason', 'The reason for freezing the server.', required: false, max_length: 1000, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
end

bot.register_application_command(:unfreeze, 'Unlock the timeout caused by using the freeze command.', contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
  option.string('reason', 'The reason for un-freezing the server.', required: false, max_length: 1000, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
end

bot.register_application_command(:archive, 'Archives pins in a specified channel.', default_member_permissions: 8192, contexts: [0], integration_types: [0], name_localizations: { 'hi' => 'पुरातत्व' }, description_localizations: { 'hi' => 'पुरातत्व पिंस कोई चुनित चैनल मै' }) do |option|
  option.channel('channel', 'Which channel needs to have its pins archived?', required: true, types: [:text], name_localizations: { 'hi' => 'प्रवाह' }, description_localizations: { 'hi' => 'कौनसे चैनल को उसके पुरातत्व पिंस की जरूरत है' })
end

bot.register_application_command(:eval, 'Allows the bot owner to execute code.', default_member_permissions: 0, contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => 'बोट ऑनर को कोड रन करनेकी इजाजत है' }) do |option|
  option.string('code', 'The code you want to execute.', required: true, name_localizations: { 'hi' => 'कोड' }, description_localizations: { 'hi' => 'कोड जो रन करना है' })
  option.boolean('ephemeral', 'Whether the output should only be visible to you.', required: true, name_localizations: { 'hi' => 'अल्पकालिक' }, description_localizations: { 'hi' => 'क्या आपको ही बस आउटपुट दिखना चाहिए?' })
end

bot.register_application_command(:moon, 'moon commands', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |command|
  command.subcommand('phase', 'Shows the current phase of the moon!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
  end
end

bot.register_application_command(:settings, 'View your server configuration.', default_member_permissions: 32, contexts: [0], integration_types: [0], name_localizations: { 'hi' => 'सेटिंग्स' }, description_localizations: { 'hi' => 'आपना सर्वर कॉन्फिग्रेशन देखो' }) do |option|
end

bot.register_application_command(:shutdown, 'Safely disconnects the bot from the Gateway.', default_member_permissions: 0, contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'बंधकरो' }, description_localizations: { 'hi' => 'सावधानी से बोट को गेटवे से डिसकनेक्ट करो' }) do |option|
end

bot.register_application_command(:restart, 'Safely restarts and reconnects the bot to the Gateway.', default_member_permissions: 0, contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
end

bot.register_application_command(:throw, 'Snowball fights', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'फेंको' }, description_localizations: { 'hi' => 'बर्फ का गोला की लड़ीं' }) do |command|
  command.subcommand('snowball', 'Throw a snowball at someone!', name_localizations: { 'hi' => 'बर्फ का लोग' }, description_localizations: { 'hi' => 'बर्फ का गोला फेक' }) do |option|
    option.user('member', 'Who do you want to hit with a snowball?', required: true, name_localizations: { 'hi' => 'लोग' }, description_localizations: { 'hi' => 'बर्फ का गोला किसे मारना चाहते हो' })
  end
end

bot.register_application_command(:collect, 'Snowball fights', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'जमा' }, description_localizations: { 'hi' => 'बर्फ का गोला की लड़ीं' }) do |command|
  command.subcommand('snowball', 'Collect a snowball!', name_localizations: { 'hi' => 'बर्फ का लोग' }, description_localizations: { 'hi' => 'बर्फ का गोला जमा करो' }) do |sub|
  end
end

bot.register_application_command(:steal, 'Snowball fights', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'चोरी' }, description_localizations: { 'hi' => 'बर्फ का गोला की लड़ीं' }) do |command|
  command.subcommand('snowball', 'Steal a snowball from someone!', name_localizations: { 'hi' => 'बर्फ का लोग' }, description_localizations: { 'hi' => 'बर्फ का लोग किसी से चूरो' }) do |option|
    option.user('member', 'Who do you want to steal snowballs from?', required: true, name_localizations: { 'hi' => 'लोग' }, description_localizations: { 'hi' => 'किस से बर्फ का लोग चोरी करना है' })
    option.integer('amount', 'How many snowballs do you want to steal?', choices: { two: '2', three: '3', four: '4', five: '5' }, required: true, name_localizations: { 'hi' => 'अमाउंट' }, description_localizations: { 'hi' => 'कितने बर्फ के गोले चुराने है' })
  end
end

bot.register_application_command(:create, 'tags', contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |command|
  command.subcommand('tag', 'Create a tag!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
    option.string('name', 'The name of the tag to create.', required: true, max_length: 100, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
    option.string('message', 'A message with the content to include in the tag.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
  end
end

bot.register_application_command(:view, 'tags', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |command|
  command.subcommand('tag', 'View a specific tag.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
    option.string('name', 'The name of the tag to view.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
    option.user('member', 'A member to member to mention when viewing this tag.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
  end
end

bot.register_application_command(:delete, 'tags', contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |command|
  command.subcommand('tag', 'Delete a specific tag.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
    option.string('name', 'The name of the tag to delete.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
  end
end

bot.register_application_command(:tag, 'tags', contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |command|
  command.subcommand('info', 'Get information about a certain tag.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
    option.string('name', 'The name of the tag to get.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
  end
end

bot.register_application_command(:update, 'Contributors', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'अपडेट' }, description_localizations: { 'hi' => 'सहकारी गण' }) do |command|
  command.subcommand('status', "Update the status that's show by the bot.", name_localizations: { 'hi' => 'स्टेटस' }, description_localizations: { 'hi' => 'अपटेड स्टेटस जो बोट दिखा रहा है' }) do |option|
    option.string('description', 'The status that the bot should display.', required: false, name_localizations: { 'hi' => 'डिस्क्रिप्शन' }, description_localizations: { 'hi' => 'स्टेटस जो बोट की दिखाना चाहिए' })
    option.string('type', 'The type of online status that the bot should display.', choices: { online: 'Online', idle: 'Idle', dnd: 'DND' }, required: false, name_localizations: { 'hi' => 'प्रजाति' }, description_localizations: { 'hi' => 'कौनसी प्रजाति का स्टेटस बोट की दिखाना चाहिए' })
  end
end

bot.register_application_command(:music, 'Connect and play audio over a voice channel.', name_localizations: { 'hi' => 'गाना' }, description_localizations: { 'hi' => 'आवाज चलाओ किसी लिंक या गाने के नाम से' }) do |command|
  command.subcommand(:disconnect, 'Disconnect from a voice channel.', name_localizations: { 'hi' => 'अलग करो' }, description_localizations: { 'hi' => 'वॉयस चैनल बंद करो' })
  command.subcommand(:resume, 'Resume playback in a voice channel.', name_localizations: { 'hi' => 'फिर शुरू करना' }, description_localizations: { 'hi' => 'वॉइस चैनल में प्लेबैक फिर से शुरू करे' })
  command.subcommand(:pause, 'Pause playback in a voice channel.', name_localizations: { 'hi' => 'ठहराव' }, description_localizations: { 'hi' => 'वॉइस चैनल में प्लेबैक रोके' })
  command.subcommand(:stop, 'Stop playing the current song.', name_localizations: { 'hi' => 'रोकना' }, description_localizations: { 'hi' => 'अभी का गाना बंद करो' })
  command.subcommand(:help, 'Help menu for music commands.', name_localizations: { 'hi' => 'मदत' }, description_localizations: { 'hi' => 'मदत वॉयस चैनल के लिए' })
  command.subcommand(:play, 'Play audio from a URL or a song name.', name_localizations: { 'hi' => 'नाटक' }, description_localizations: { 'hi' => 'आवाज चलाओ किसी लिंक या गाने के नाम से' }) do |option|
  option.string(:song, 'Spotify, Apple Music, YouTube URL, or a song name.', required: true, min_length: 2, name_localizations: { 'hi' => 'गाना' }, description_localizations: { 'hi' => 'स्पॉटीफाई एप्पल म्यूजिक या गाने का नाम' })
  end
end

bot.register_application_command(:pin, 'Pin archive', default_member_permissions: 0, contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => 'पिन' }, description_localizations: { 'hi' => 'की पुरातत्' }) do |command|
  command.subcommand_group(:archiver, 'Pin Archival!', name_localizations: { 'hi' => 'संग्रहकर्ता' }, description_localizations: { 'hi' => 'की पुरातत्व' }) do |group|
    group.subcommand(:setup, 'Setup the pin-archiver functionality.', name_localizations: { 'hi' => 'बंदोबस्त' }, description_localizations: { 'hi' => 'पिन की पुरातत्व की कंडीशन' }) do |option|
      option.channel('channel', 'Which channel should archived pins be sent to?', required: true, types: [:text], name_localizations: { 'hi' => 'प्रवाह' }, description_localizations: { 'hi' => 'किधर पुरातात्विक पिंस जाने चाहिए' })
    end

    group.subcommand(:disable, 'disable the pin-archiver functionality.', name_localizations: { 'hi' => 'बंद करने' }, description_localizations: { 'hi' => 'पिन पुरातत्व कंडीशन को बंद करो' }) do |option|
    end
  end
end

bot.register_application_command(:events, 'Event roles setup', default_member_permissions: 0, contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |command|
  command.subcommand_group(:role, 'Event roles!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |group|
    group.subcommand(:setup, 'Setup the event roles functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
      option.role('role', 'Which role should be modifiable by its users?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
    end

    group.subcommand(:disable, 'Disable the event roles functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
    end
  end
end

bot.register_application_command(:event, 'Event roles', contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |command|
  command.subcommand_group(:roles, 'Event roles!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |group|
    group.subcommand(:edit, 'Edit your event role.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
      option.role('role', 'Which role do you want to modifiy?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
      option.string('name', 'Provide a name for your role.', required: false, max_length: 100, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
      option.string('color', 'Provide a HEX color for your role.', required: false, min_length: 6, max_length: 7, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
      option.string('icon', 'Provide an emoji to serve as your role icon.', required: false, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
    end
  end
end

bot.register_application_command(:boost, 'Booster perks admin', default_member_permissions: 268435456, contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |command|
  command.subcommand_group(:admin, 'Booster admin!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |group|
    group.subcommand('add', "Manually add a 'booster' to the database.", name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
      option.user('user', 'The user to add to the database.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
      option.role('role', 'The role to add to the database.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
    end

    group.subcommand('delete', 'Manually remove a user from the database!') do |option|
      option.user('user', 'The user to remove from the database.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
    end

    group.subcommand('ban', 'Ban a user from using the booster perks functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
      option.user('user', 'The user to ban.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
    end

    group.subcommand('unban', 'Unban a user from using the booster perks functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
      option.user('user', 'The user to unban.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
    end

    group.subcommand('setup', 'Setup the booster perks functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
      option.role('role', 'Which role should all custom booster roles be placed above?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
    end

    group.subcommand('disable', 'Disable the booster perks functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
    end

    group.subcommand('help', 'Open the administrator help menu for this functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
    end
  end
end  

bot.register_application_command(:booster, 'Booster perks', contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |command|
  command.subcommand_group(:role, 'Booster roles!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |group|
    group.subcommand('claim', 'Claim your custom booster role!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
        option.string('name', 'Provide a name for your role.', required: true, max_length: 100, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
        option.string('color', 'Provide a HEX color for your role.', required: true, min_length: 6, max_length: 7, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
        option.string('icon', 'Provide an emoji to serve as your role icon.', required: false, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
      end

      group.subcommand('edit', 'Edit your custom booster role!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
        option.string('name', 'Provide a name for your role.', required: false, max_length: 100, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
        option.string('color', 'Provide a HEX color for your role.', required: false, min_length: 6, max_length: 7, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
        option.string('icon', 'Provide an emoji to serve as your role icon.', required: false, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
      end

      group.subcommand('delete', 'Delete your custom booster role.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |sub|
      end

      group.subcommand('help', 'Open the booster perks help menu.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |sub|
    end
  end
end

at_exit { bot.stop }

bot.run
