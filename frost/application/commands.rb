# frozen_string_literal: true

# Return unless we want to register our commands.
return unless ENV.fetch("REGISTER_COMMANDS", nil)

# Create a bot instance since our main instance doesn't exist yet.
bot = Discordrb::Bot.new(token: ENV.fetch("TOKEN"), intents: :none)

# @!function [General Operations] Belongs to a module that manages general information.
bot.register_application_command(:info, "View information about the bot.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { hi: "सेटिंग्स" }, description_localizations: { hi: "आपना सर्वर कॉन्फिग्रेशन देखो" })

# @!function [Affections] Belongs to a module that does expressions.
bot.register_application_command(:hug, "Hugs another user.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { hi: "गलेमिलना" }, description_localizations: { hi: "सर्वर मित्र के गले मिलना" }) do |option|
  option.user(:target, "Who do you want to hug?", required: true, name_localizations: { hi: "इशारालगाना" }, description_localizations: { hi: "किसको गले मिलना है" })
end

# @!function [Affections] Belongs to a module that does expressions.
bot.register_application_command(:poke, "Pokes another user.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { hi: "बुलाना" }, description_localizations: { hi: "कोई सर्वर मित्र को बुलाना" }) do |option|
  option.user(:target, "Who do you want to poke?", required: true, name_localizations: { hi: "इशारालगाना" }, description_localizations: { hi: "किसको बुलाना है" })
end

# @!function [Affections] Belongs to a module that does expressions.
bot.register_application_command(:nom, "Noms another user.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { hi: "कुतरना" }, description_localizations: { hi: "किसी अन्य सर्वर सदस्य को काटता है" }) do |option|
  option.user(:target, "Who do you want to nom?", required: true, name_localizations: { hi: "इशारालगाना" }, description_localizations: { hi: "आप किसे काटना चाहते हैं?" })
end

# @!function [Affections] Belongs to a module that does expressions.
bot.register_application_command(:angered, "Show your anger towards another user.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { hi: "गुस्साकरना" }, description_localizations: { hi: "कोई सर्वर मित्र पे गुस्सा दिखाना" }) do |option|
  option.user(:target, "Who are you mad at?", required: true, name_localizations: { hi: "इशारालगाना" }, description_localizations: { hi: "किसपे आपको गुस्सा दिखाना है" })
end

# @!function [Affections] Belongs to a module that does expressions.
bot.register_application_command(:bonk, "Bonk another user.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { hi: "टपलीमारना" }, description_localizations: { hi: "किसी सर्वर मित्र को टपाली मारना" }) do |option|
  option.user(:target, "Who do you want to bonk?", required: true, name_localizations: { hi: "इशारालगाना" }, description_localizations: { hi: "किसको टपाली मारना है" })
end

# @!function [Affections] Belongs to a module that does expressions.
bot.register_application_command(:punch, "Punch another user.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { hi: "मुक्का" }, description_localizations: { hi: "एक सर्वर मित्र को मुक्का मारो" }) do |option|
  option.user(:target, "Who do you want to punch?", required: true, name_localizations: { hi: "इशारालगाना" }, description_localizations: { hi: "आप किसे मुक्का मारना चाहते हैं?" })
end

# @!function [General Operations] Belongs to a module that manages general information.
bot.register_application_command(:time, "View the current time.", contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { hi: "समय" }, description_localizations: { hi: "वर्तमान समय देखें" }) do |option|
  option.string(:timezone, "The timezone to view the time in.", required: true, autocomplete: true, name_localizations: { hi: "समयक्षेत्र" }, description_localizations: { hi: "आप किस समयक्षेत्र का समय देखना चाहते हैं" })
end

# @!function [General Operations] Belongs to a module that manages general information.
bot.register_application_command(:next, "View the release date of the next chapter.", server_id: ENV.fetch("GUILD"), contexts: [0], integration_types: [0], name_localizations: { hi: "अगला" }, description_localizations: { hi: "मंगा अध्याय" }) do |command|
  command.subcommand_group(:chapter, "View the release date of the next chapter.", name_localizations: { hi: "प्रकरण" }, description_localizations: { hi: "कॉमिक्स" }) do |group|
    group.subcommand(:when, "View the release date of the next chapter.", name_localizations: { hi: "कब" }, description_localizations: { hi: "अगला अध्याय कब आ रहा है" })
  end
end

# @!function [Moderation Operations] Belongs to a module that manages moderation related commands.
bot.register_application_command(:purge, "Remove messages that meet a criteria.", contexts: [0], integration_types: [0], default_member_permissions: "11_264") do |command|
  command.subcommand(:messages, "Remove messages that meet a criteria.") do |option|
    option.integer(:amount, "The maximum number of messages to delete.", required: true, min_value: 1, max_value: 700)
    option.user(:member, "Remove messages from a specific member.", required: false)
    option.string(:contains, "Remove messages that contain this text (case sensitive).", required: false)
    option.mentionable(:mentions, "Remove messages that mention this entity.", required: false)
    option.boolean(:reaction, "Remove messages that have reactions.", required: false)
    option.boolean(:embeds, "Remove messages that have embeds.", required: false)
    option.string(:before, "Remove messages the come before this message ID.", required: false)
    option.string(:prefix, "Remove messages that start with this text (case sensitive).", required: false)
    option.string(:suffix, "Remove messages that end with this text (case sensitive).", required: false, min_length: 1)
    option.boolean(:robot, "Remove messages from bot accounts (not webhooks).", required: false)
    option.boolean(:emoji, "Remove messages that have custom emojis.", required: false)
    option.string(:after, "Remove messages the come after this message ID.", required: false, min_length: 16, max_length: 21)
    option.boolean(:files, "Remove messages that have attachments.", required: false)
  end
end

# @!function [Event Operations] Belongs to a module that manages event roles.
bot.register_application_command(:event, "Role management for server events.", contexts: [0], integration_types: [0]) do |command|
  command.subcommand_group(:role, "Event Roles") do |group|
    group.subcommand(:remove, "Remove one of your event roles.") do |option|
      option.role(:role, "The event role that you want to remove.", required: true)
    end

    group.subcommand(:members, "Manage the members for an event role.") do |option|
      option.role(:role, "The event role that you want to manage members for.", required: true)
    end

    group.subcommand(:equip, "Equip one of your event roles.") do |option|
      option.role(:role, "The event role that you want to equip.", required: true)
      option.boolean(:display, "whether to set the event role as your primary role.", required: true)
    end

    group.subcommand(:enable, "Enable the event roles functionality for a role.") do |option|
      option.role(:role, "The role to enable the event roles functionality for.", required: true)
    end

    group.subcommand(:disable, "Disable the event roles functionality for an event role.") do |option|
      option.role(:role, "The role to disable the event roles functionality for.", required: true)
    end
  end
end

# @!function [Birthday Operations] Belongs to a module that manages birthday roles.
bot.register_application_command(:birthday, "Customizable birthday roles and announcements.", contexts: [0], integration_types: [0]) do |command|
  command.subcommand(:add, "Add or edit your date of birth.") do |option|
    option.integer(:month, "The month you were born in.", required: true, choices: { January: 1, February: 2, March: 3, April: 4, May: 5, June: 6, July: 7, August: 8, September: 9, October: 10, November: 11, December: 12 })
    option.integer(:day, "The day you were born on.", required: true, min_value: 1, max_value: 31)
    option.string(:timezone, "The timezone you were born in.", required: true, autocomplete: true, min_length: 5, max_length: 35)
  end

  command.subcommand(:sync, "Sync your date of birth to this server.")

  command.subcommand(:delete, "Remove your date of birth from the bot.")

  command.subcommand_group(:admin, "Birthday Admin") do |group|
    group.subcommand(:enable, "Enable the birthday perks functionality.") do |option|
      option.role(:role, "The role members should be given on their birthday.", required: false)
      option.channel(:channel, "The channel birthday annoucements should be sent to.", types: [:text], required: false)
    end

    group.subcommand(:disable, "Disable the birthday perks functionality.")
  end
end

# @!function [Booster Operations] Belongs to a module that manages booster roles.
bot.register_application_command(:booster, "Customizable perks for server boosters.", contexts: [0], integration_types: [0]) do |command|
  command.subcommand_group(:role, "Booster Perks") do |group|
    group.subcommand(:claim, "Claim your custom booster role.") do |option|
      option.string(:name, "Provide a name for your role.", required: true, max_length: 100)
      option.string(:color, "Provide a HEX color for your role.", required: true, min_length: 3, max_length: 16)
      option.string(:icon, "Provide an emoji for your role icon.", required: false)
    end

    group.subcommand(:edit, "Edit your custom booster role.") do |option|
      option.string(:name, "Provide a name for your role.", required: false, max_length: 100)
      option.string(:color, "Provide a HEX color for your role.", required: false, min_length: 3, max_length: 16)
      option.string(:icon, "Provide an emoji for your role icon.", required: false)
    end

    group.subcommand(:gradient, "Edit your custom booster role's gradient.") do |option|
      option.string(:start, "Provide a HEX color for your gradient's start color.", required: false, min_length: 3, max_length: 16)
      option.string(:end, "Provide a HEX color for your gradient's end color.", required: false, min_length: 3, max_length: 16)
      option.boolean(:holographic, "Whether to use the holographic preset for the gradient.", required: false)
    end

    group.subcommand(:delete, "Delete your custom booster role.")
  end

  command.subcommand_group(:admin, "Booster Admin") do |group|
    group.subcommand(:add, "Add a booster to this server.") do |option|
      option.user(:target, "The member to add as a booster.", required: true)
      option.role(:role, "The role to associate with the member.", required: true)
    end

    group.subcommand(:delete, "Remove a booster from this server.") do |option|
      option.user(:target, "The booster to remove from the server.", required: true)
      option.boolean(:prune, "Whether to delete the member's booster role.", required: true)
    end

    group.subcommand(:enable, "Enable the booster perks functionality.") do |option|
      option.role(:role, "The role that all booster roles should be moved above.", required: false)
      option.boolean(:icon, "Whether external emojis should be allowed as role icons.", required: false)
    end

    group.subcommand(:disable, "Disable the booster perks functionality.")

    group.subcommand(:bans, "Manage the members banned from using booster perks.")
  end
end
