# frozen_string_literal: true

module Settings
  # Responses and fields for setting commands.
  RESPONSE = {
    1 => "Hi! Welcome to my help page. Use the dropdown menu below to view a category.\n\n**About Me**\nI was made by droid00000. My code is open source and can be viewed [here!](https://github.com/Droid00000/Frost)\n\n",
    2 => "These are the enabled event roles for your server. Roles can be removed with the </event role disable:1342292560378466346> command, and added with the </event role enable:1342292560378466346> command.",
    3 => "These are the booster settings for your server. Server boosters can be added, removed, banned, unbanned, and managed with the **/booster admin** command group.",
    4 => "These are the birthday settings for your server. Birthday perks can be enabled, edited, and disabled with the **/birthday admin** command group.",
    5 => "**Icon**\nServer boosters may use any custom or unicode emojis and as their role icon.",
    6 => "**Icon**\nServer boosters may only use server and unicode emojis as their role icon.",
    7 => "**Manager**\nBirthday perks were enabled in this server by **%s** on <t:%s:D>\n\n",
    8 => "**Hoist Role**\nAll newly created roles will be moved above this role: <@&%s>\n\n",
    9 => "**Birthday Role**\nMembers will be given this role on their birthday: <@&%s>\n\n",
    10 => "**Manager**\nBooster perks were enabled in this server by **%s** on <t:%s:D>\n\n",
    11 => "**Channel**\nMembers will have their birthdays announced in this channel: <#%s>",
    12 => "**Stats**\nI'm on %s servers with a total of %s members and %s channels.",
    13 => "This feature has not been enabled.",
    14 => "-# Viewing %s out of %s roles",
    15 => "### Birthday Perks for %s",
    16 => "### Booster Perks for %s",
    17 => "### Event Roles for %s",
    18 => "### Main Menu"
  }.freeze

  # Application commands for general commands.
  COMMANDS = {
    1 => "`/info`"
  }.freeze

  # Resolve the select menu.
  def self.menu(data)
    case data.values[0].to_sym
    when :Events
      events(data)
    when :Boosters
      boosters(data)
    when :Birthdays
      birthdays(data)
    end
  end
end
