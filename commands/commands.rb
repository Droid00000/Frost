# frozen_string_literal: true

# We register our application commands using a seperate script so we don't need to register them every time the bot starts.

require 'toml-rb'
require 'discordrb'
require_relative '../data/constants'

bot = Discordrb::Bot.new(token: TOML['Discord']['TOKEN'], intents: [:servers])

bot.ready do
  bot.update_status(ACTIVITY[4], ACTIVITY[5], ACTIVITY[3])
end

bot.register_application_command(:hug, 'Hugs another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
  option.user('target', 'Who do you want to hug?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
end

bot.register_application_command(:poke, 'Pokes another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
  option.user('target', 'Who do you want to poke?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
end

bot.register_application_command(:nom, 'Noms another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
  option.user('target', 'Who do you want to nom?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
end

bot.register_application_command(:angered, 'Show your anger towards another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
  option.user('target', 'Who do you want to show your wrath to?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
end

bot.register_application_command(:bonk, 'Bonk another server member.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
  option.user('target', 'Who do you want to bonk?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
end

bot.register_application_command(:sleep, 'Tells another server member to go and sleep.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
  option.user('target', 'Who needs to sleep?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
end

bot.register_application_command(:help, 'Shows some general information about how to use the bot.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
end

bot.register_application_command(:about, 'Shows some general information about the bot.', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
end

bot.register_application_command(:archive, 'Archives pins in a specified channel.', default_member_permissions: 8192, contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
  option.channel('channel', 'Which channel needs to have its pins archived?', required: true, types: [:text], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
end

bot.register_application_command(:eval, 'Allows the bot owner to execute code.', default_member_permissions: 0, contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
  option.string('code', 'The code you want to execute.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
  option.boolean('ephemeral', 'Whether the output should only be visible to you.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
end

bot.register_application_command(:settings, 'View your server configuration.', default_member_permissions: 32, contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
end

bot.register_application_command(:shutdown, 'Safely disconnects the bot from the Gateway.', default_member_permissions: 0, contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
end

bot.register_application_command(:throw, 'Snowball fights', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |cmd|
  cmd.subcommand('snowball', 'Throw a snowball at someone!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
    option.user('member', 'Who do you want to hit with a snowball?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
  end
end

bot.register_application_command(:collect, 'Snowball fights', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |cmd|
  cmd.subcommand('snowball', 'Collect a snowball!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |sub|
  end
end

bot.register_application_command(:steal, 'Snowball fights', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |cmd|
  cmd.subcommand('snowball', 'Steal a snowball from someone!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
    option.user('member', 'Who do you want to steal snowballs from?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
    option.integer('amount', 'How many snowballs do you want to steal?', choices: { two: '2', three: '3', four: '4', five: '5' }, required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
  end
end

bot.register_application_command(:update, 'Contributors', contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |cmd|
  cmd.subcommand('status', "Update the status that's show by the bot.", name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
    option.string('description', 'The status that the bot should display.', required: false, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
    option.string('type', 'The type of online status that the bot should display.', choices: { online: 'Online', idle: 'Idle', dnd: 'DND' }, required: false, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
  end
end

bot.register_application_command(:music, 'Connect and play audio over a voice channel.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |command|
  command.subcommand(:disconnect, 'Disconnect from a voice channel.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
  command.subcommand(:stop, 'Stop playing the current song.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
  command.subcommand(:help, 'Help menu for voice commands.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
  command.subcommand(:play, 'Play audio from a URL or a song name.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
    option.string(:url, 'Spotify, Apple Music, YouTube URL, or a song name.', required: true, min_length: 2, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
  end
end

bot.register_application_command(:pin, 'Pin archive', default_member_permissions: 0, contexts: [0, 1, 2], integration_types: [0, 1], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |cmd|
  cmd.subcommand_group(:archiver, 'Pin Archival!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |group|
    group.subcommand(:setup, 'Setup the pin-archiver functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
      option.channel('channel', 'Which channel should archived pins be sent to?', required: true, types: [:text], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
    end

    group.subcommand(:disable, 'disable the pin-archiver functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
    end
  end
end

bot.register_application_command(:events, 'Event roles setup', default_member_permissions: 0, contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |cmd|
  cmd.subcommand_group(:role, 'Event roles!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |group|
    group.subcommand(:setup, 'Setup the event roles functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
      option.role('role', 'Which role should be modifiable by its users?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
    end

    group.subcommand(:disable, 'Disable the event roles functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
    end
  end
end

bot.register_application_command(:event, 'Event roles', contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |cmd|
  cmd.subcommand_group(:roles, 'Event roles!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |group|
    group.subcommand(:edit, 'Edit your event role.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
      option.role('role', 'Which role do you want to modifiy?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
      option.string('name', 'Provide a name for your role.', required: false, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
      option.string('color', 'Provide a HEX color for your role.', required: false, min_length: 6, max_length: 7, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
      option.string('icon', 'Provide an emoji to serve as your role icon.', required: false, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
    end
  end

  bot.register_application_command(:boost, 'Booster perks admin', default_member_permissions: 268435456, contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |cmd|
    cmd.subcommand_group(:admin, 'Booster admin!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |group|
      group.subcommand('add', "Manually add a 'booster' to the database.", name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
        option.user('user', 'The user to add to the database.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
        option.role('role', 'The role to add to the database.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
      end

      group.subcommand('delete', 'Manually remove a user from the database!') do |option|
        option.user('user', 'The user to remove from the database.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
      end

      group.subcommand('ban', 'Blacklist a user from using the booster perks functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
        option.user('user', 'The user to blacklist.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
      end

      group.subcommand('unban', 'Blacklist a user from using the booster perks functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
        option.user('user', 'The user to un-blacklist.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
      end

      group.subcommand('setup', 'Setup the booster perks functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
        option.role('role', 'Which role should al custom booster roles be placed above?', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
      end

      group.subcommand('disable', 'disable the booster perks functionality.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
      end

      group.subcommand('help', 'Open the administrator help menu for this functionality.'), name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' } do |option|
      end
    end

    bot.register_application_command(:booster, 'Booster perks', contexts: [0], integration_types: [0], name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |cmd|
      cmd.subcommand_group(:role, 'Booster roles!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |group|
        group.subcommand('claim', 'Claim your custom booster role!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
          option.string('name', 'Provide a name for your role.', required: true, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
          option.string('color', 'Provide a HEX color for your role.', required: true, min_length: 6, max_length: 7, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
          option.string('icon', 'Provide an emoji to serve as your role icon.', required: false, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
        end

        group.subcommand('edit', 'Edit your custom booster role!', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |option|
          option.string('name', 'Provide a name for your role.', required: false, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
          option.string('color', 'Provide a HEX color for your role.', required: false, min_length: 6, max_length: 7, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
          option.string('icon', 'Provide an emoji to serve as your role icon.', required: false, name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' })
        end

        group.subcommand('delete', 'Delete your custom booster role.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |sub|
        end

        group.subcommand('help', 'Open the booster perks help menu.', name_localizations: { 'hi' => '' }, description_localizations: { 'hi' => '' }) do |sub|
        end
      end
    end
  end
end

at_exit { bot.stop }

bot.run
