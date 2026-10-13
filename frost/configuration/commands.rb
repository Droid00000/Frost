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

    bot.create_application_command(:angered, "Show another user you're angry.", contexts: %i[guild bot_dm private_channel], integration_types: %i[user guild], queue: true) do |option|
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
      command.subcommand(:roles, "Manage your event roles.")

      command.subcommand_group(:role, "Event Roles") do |group|
        group.subcommand(:configure, "Configure an event role.")

        group.subcommand(:disable, "Disable an event role.") do |option|
          option.role(:role, "The event role that you want to disable.", required: true)
        end
      end
    end

    bot.register_application_command(:birthday, "Customizable birthday roles and announcements.", contexts: [:guild], integration_types: [:guild], queue: true) do |command|
      command.subcommand(:add, "Add or edit your birthday.") do |option|
        option.integer(:month, "The month you were born in.", required: true, choices: { January: 1, February: 2, March: 3, April: 4, May: 5, June: 6, July: 7, August: 8, September: 9, October: 10, November: 11, December: 12 })
        option.integer(:day, "The day you were born on.", required: true, min: 1, max: 31)
        option.string(:timezone, "The timezone you were born in.", required: true, autocomplete: true, min: 5, max: 35)
      end

      command.subcommand(:sync, "Sync your birthday to this server.")

      command.subcommand(:delete, "Remove your birthday from the bot.")

      command.subcommand_group(:admin, "Birthday Admin") do |group|
        group.subcommand(:disable, "Disable the birthday perks functionality.")

        group.subcommand(:configure, "Configure the birthday perks functionality.")
      end
    end

    bot.register_application_command(:booster, "Customizable perks for server boosters.", contexts: [:guild], integration_types: [:guild], queue: true) do |command|
      command.subcommand_group(:role, "Booster Perks") do |group|
        group.subcommand(:claim, "Claim your custom booster role.") do |option|
          option.string(:name, "Provide a name for your role.", required: true, max: 100)
          option.string(:color, "Provide a HEX color for your role.", required: true, min: 3, max: 16)
          option.string(:icon, "Provide an emoji for your role icon.", required: false)
        end

        group.subcommand(:edit, "Edit your custom booster role.") do |option|
          option.string(:name, "Provide a name for your role.", required: false, max: 100)
          option.string(:color, "Provide a HEX color for your role.", required: false, min: 3, max: 16)
          option.string(:icon, "Provide an emoji for your role icon.", required: false)
        end

        group.subcommand(:gradient, "Edit your custom booster role's gradient.") do |option|
          option.string(:start, "Provide a HEX color for your gradient's start color.", required: false, min: 3, max: 16)
          option.string(:end, "Provide a HEX color for your gradient's end color.", required: false, min: 3, max: 16)
          option.boolean(:holographic, "Whether to use the holographic preset for the gradient.", required: false)
        end

        group.subcommand(:delete, "Delete your custom booster role.")
      end

      command.subcommand_group(:admin, "Booster Admin") do |group|
        group.subcommand(:add, "Add a booster to this server.") do |option|
          option.user(:target, "The member for the booster.", required: true)
          option.role(:role, "The role to link to the booster.", required: true)
        end

        group.subcommand(:delete, "Remove a booster from this server.") do |option|
          option.user(:target, "The booster to remove from this server.", required: true)
          option.boolean(:prune, "Whether to delete the member's booster role.", required: true)
        end

        group.subcommand(:disable, "Disable the booster perks functionality.")

        group.subcommand(:configure, "Configure the booster perks functionality.")

        group.subcommand(:bans, "Manage the members banned from using booster perks.")
      end
    end

    bot.sync_application_commands(merge: true)
  end

  register_application_commands(BOT.discord) if ENV["REGISTER_SLASH_COMMANDS"] == "true"
end
