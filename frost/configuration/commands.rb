# frozen_string_literal: true

module Frost::Commands
  # Register all of the application commands for the bot.
  def self.register_application_commands(bot)
    bot.register_application_command(:info, "View information about the bot.", contexts: %i[guild bot_dm private_channel], integration_types: %i[user guild], queue: true)

    bot.create_application_command(:hug, "Hug another user.", contexts: %i[guild bot_dm private_channel], integration_types: %i[user guild], queue: true) do |option|
      option.user(:target, "Who do you want to hug?", required: true)
    end

    bot.create_application_command(:nom, "Nom another user.", contexts: %i[guild bot_dm private_channel], integration_types: %i[user guild], queue: true) do |option|
      option.user(:target, "Who do you want to nom?", required: true)
    end

    bot.create_application_command(:poke, "Poke another user.", contexts: %i[guild bot_dm private_channel], integration_types: %i[user guild], queue: true) do |option|
      option.user(:target, "Who do you want to poke?", required: true)
    end

    bot.create_application_command(:angered, "Show your anger towards another user.", contexts: %i[guild bot_dm private_channel], integration_types: %i[user guild], queue: true) do |option|
      option.user(:target, "Who are you mad at?", required: true)
    end

    bot.create_application_command(:bonk, "Bonk another user.", contexts: %i[guild bot_dm private_channel], integration_types: %i[user guild], queue: true) do |option|
      option.user(:target, "Who do you want to bonk?", required: true)
    end

    bot.register_application_command(:punch, "Punch another user.", contexts: %i[guild bot_dm private_channel], integration_types: %i[user guild], queue: true) do |option|
      option.user(:target, "Who do you want to punch?", required: true)
    end

    bot.register_application_command(:time, "View the current time.", contexts: %i[guild bot_dm private_channel], integration_types: %i[user guild], queue: true) do |option|
      option.string(:timezone, "The timezone to view the time in.", required: true, autocomplete: true)
    end

    if (guild_id = ENV.fetch("GUILD", nil))
      bot.register_application_command(:next, "View the release date of the next chapter.", guild: guild_id) do |command|
        command.subcommand_group(:chapter, "View the release date of the next chapter.") do |group|
          group.subcommand(:when, "View the release date of the next chapter.")
        end
      end
    end

    bot.register_application_command(:event, "Role management for server events.", contexts: [:guild], integration_types: [:guild], queue: true) do |command|
      command.subcommand_group(:role, "Event Roles") do |group|
        group.subcommand(:remove, "Remove one of your event roles.") do |option|
          option.role(:role, "The event role that you want to remove.", required: true)
        end

        group.subcommand(:members, "Manage the members for an event role.") do |option|
          option.role(:role, "The event role that you want to manage members for.", required: true)
        end

        group.subcommand(:add, "Add one of your event roles.") do |option|
          option.role(:role, "The event role that you want to add.", required: true)
          option.boolean(:display, "whether to set the event role as your main event role.", required: true)
        end
      end
    end

    bot.register_application_command(:birthday, "Customizable birthday roles and announcements.", contexts: [:guild], integration_types: [:guild], queue: true) do |command|
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

    bot.register_application_command(:booster, "Customizable perks for server boosters.", contexts: [:guild], integration_types: [:guild], queue: true) do |command|
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

    bot.sync_application_commands(merge: false)
  end
end
