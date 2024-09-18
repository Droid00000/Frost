# frozen_string_literal: true

# We register our application commands using a seperate script so we don't need to register them every time the bot starts.

require 'toml-rb'
require 'discordrb'
require_relative '../data/constants'

TOML = TomlRB.load_file('config.toml')

bot = Discordrb::Bot.new(token: TOML['Discord']['RAW_TOKEN'], intents: [:server_messages])

bot.ready do
  bot.update_status(ACTIVITY[80], ACTIVITY[90], ACTIVITY[70])
end

bot.register_application_command(:hug, 'Hugs another server member.') do |option|
  option.user('target', 'Who do you want to hug?', required: true)
end

bot.register_application_command(:poke, 'Pokes another server member.') do |option|
  option.user('target', 'Who do you want to poke?', required: true)
end

bot.register_application_command(:nom, 'Noms another server member.') do |option|
  option.user('target', 'Who do you want to nom?', required: true)
end

bot.register_application_command(:angered, 'Shows your anger another server member.') do |option|
  option.user('target', 'Who do you want to show your wrath to?', required: true)
end

bot.register_application_command(:sleep, 'Tell another server member to go and sleep.') do |option|
  option.user('target', 'Who needs to sleep?', required: true)
end

bot.register_application_command(:help, 'Shows some general information about how to use the bot.') do |option|
end

bot.register_application_command(:about, 'Shows some information about the bot owner.') do |option|
end

bot.register_application_command(:archive, 'Archives pins in a specified channel.',
                                 default_member_permissions: 8192) do |option|
  option.channel('channel', 'Which channel needs to have its pins archived?', required: true)
end

bot.register_application_command(:settings, 'View your server configuration.',
                                 default_member_permissions: 32) do |option|
end

bot.register_application_command(:shutdown, 'Safely disconnects the bot from the Gateway.',
                                 default_member_permissions: 0) do |option|
end

bot.register_application_command(:throw, 'Snowball fights') do |cmd|
  cmd.subcommand('snowball', 'Throw a snowball at someone!') do |option|
    option.user('member', 'Who do you want to hit with a snowball?', required: true)
  end
end

bot.register_application_command(:collect, 'Snowball fights') do |cmd|
  cmd.subcommand('snowball', 'Collect a snowball!') do |sub|
  end
end

bot.register_application_command(:snowball, 'Snowball fights') do |cmd|
  cmd.subcommand('shop', 'View your balance and browse the shop.') do |sub|
  end
end

bot.register_application_command(:steal, 'Snowball fights') do |cmd|
  cmd.subcommand('snowball', 'Steal a snowball from someone!') do |option|
    option.user('member', 'Who do you want to steal snowballs from?', required: true)
    option.integer('amount', 'How many snowballs do you want to steal?',
    choices: { two: '2', three: '3', four: '4', five: '5' }, required: true)
  end
end

bot.register_application_command(:claim, 'Tags') do |cmd|
  cmd.subcommand('tag', 'claim a tag.') do |option|
    option.string('name', 'The name of the tag you want to claim.', required: true)
    option.string('message', 'The link to the message you want to claim as a tag.')
  end
end

bot.register_application_command(:view, 'Tags') do |cmd|
  cmd.subcommand('tag', 'View a tag.') do |option|
    option.string('name', 'The name of the tag to find.', required: true)
  end
end

bot.register_application_command(:disable, 'Tag admins', default_member_permissions: 0) do |cmd|
  cmd.subcommand('tags', 'Disable the tags feature on this server.') do |option|
  end
end

bot.register_application_command(:pin, 'Pin archive', default_member_permissions: 0) do |cmd|
  cmd.subcommand_group(:archiver, 'Pin Archival!') do |group|
    group.subcommand(:setup, 'Setup the pin-archiver functionality.') do |option|
      option.channel('channel', 'Which channel should archived pins be sent to?', required: true)
    end
  end
end

bot.register_application_command(:event, 'Event roles setup', default_member_permissions: 0) do |cmd|
  cmd.subcommand_group(:roles, 'Event roles!') do |group|
    group.subcommand(:setup, 'Setup the event roles functionality.') do |option|
      option.role('role', 'Which role should be modifiable by its users?', required: true)
    end
  end

  bot.register_application_command(:boosting, 'Booster perks admin', default_member_permissions: 268435456) do |cmd|
    cmd.subcommand_group(:admin, 'Booster admin!') do |group|
      group.subcommand('add', 'Manually add a user to the database.') do |option|
        option.user('user', 'The user to add to the database.', required: true)
        option.role('role', 'The role to add to the database.', required: true)
      end

      group.subcommand('delete', 'Manually delete and remove a user from the database!') do |option|
        option.user('user', 'The user to delete the database.', required: true)
        option.role('role', 'The role to delete the database.', required: true)
      end

      group.subcommand('blacklist', 'Blacklist a user from using the booster perks functionality.') do |option|
        option.user('user', 'The user to blacklist.', required: true)
      end

      group.subcommand('un-blacklist', 'Blacklist a user from using the booster perks functionality.') do |option|
        option.user('user', 'The user to un-blacklist.', required: true)
      end

      group.subcommand(:setup, 'Setup the booster perks functionality.') do |option|
        option.role('role', 'Which role should al custom booster roles be placed above?', required: true)
      end

      group.subcommand('help', 'Open the administrator help menu for this functionality.') do |option|
      end

      group.subcommand(:logging, 'Setup role logs for booster perks.') do |option|
        option.channel('channel', 'Which channel should booster perk actions be logged to?', required: true)
      end
    end

    bot.register_application_command(:booster, 'Booster perks') do |cmd|
      cmd.subcommand_group(:role, 'Booster roles!') do |group|
        group.subcommand('claim', 'Claim your custom booster role!') do |option|
          option.string('name', 'Provide a name for your role.', required: true)
          option.string('color', 'Provide a HEX color for your role.', required: true)
          option.string('icon', 'Provide an emoji to serve as your role icon.', required: false)
        end

        group.subcommand('edit', 'Edit your custom booster role!') do |option|
          option.string('name', 'Provide a name for your role.', required: false)
          option.string('color', 'Provide a HEX color for your role.', required: false)
          option.string('icon', 'Provide an emoji to serve as your role icon.', required: false)
        end

        group.subcommand('delete', 'Delete your custom booster role.') do |sub|
        end

        group.subcommand('help', 'Open the booster perks help menu.') do |sub|
        end
      end
    end
  end
end
bot.run
