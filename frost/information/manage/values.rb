# frozen_string_literal: true

module Settings
  # Responses and fields for setting commands.
  RESPONSE = {
    1 => "Hi! Welcome to my help page. Use the dropdown menu below to view a category.\n\n**About Me**\nI was made by droid00000. My code is open source and can be viewed [here!](https://github.com/Droid00000/Frost)\n\n",
    2 => "These are the booster settings for your server. Server boosters can be added, removed, banned, and unbanned with the **/booster admin** command group.",
    3 => "These are the settings for vanity roles in your server. Vanity roles can be edited, enabled, and disabled with the **/vanity role** command group.",
    4 => "These are the birthday settings for your server. Birthday perks can be enabled, edited, and disabled with the **/birthday admin** command group.",
    5 => "**Exempt Role**\nMembers must have the `manange roles` permission, or the <@&%s> role to edit vanity roles.",
    6 => "**Exempt Role**\nMembers must have the `manange roles` permission to edit vanity roles.",
    7 => "**Icon**\nServer boosters may only use server and unicode emojis as their role icon.",
    8 => "**Icon**\nServer boosters may use any custom or unicode emoji as their role icon.",
    9 => "**Manager**\nBirthday perks were enabled in this server by **%s** on <t:%s:D>\n\n",
    10 => "**Hoist Role**\nAll newly created roles will be moved above this role: <@&%s>\n\n",
    11 => "**Birthday Role**\nMembers will be given this role on their birthday: <@&%s>\n\n",
    12 => "**Manager**\nBooster perks were enabled in this server by **%s** on <t:%s:D>\n\n",
    13 => "**Manager**\nVanity roles were enabled in this server by **%s** on <t:%s:D>\n\n",
    14 => "**Channel**\nMembers will have their birthdays announced in this channel: <#%s>",
    15 => "**Stats**\nI'm on %s servers with a total of %s members and %s channels.",
    16 => "This feature has not been enabled.",
    17 => "### Birthday Perks for %s",
    18 => "### Booster Perks for %s",
    19 => "### Vanity Roles for %s",
    20 => "### Main Menu"
  }.freeze

  # Application commands for general commands.
  COMMANDS = {
    1 => "`/info`"
  }.freeze

  # Resolve the select menu.
  def self.menu(data)
    case data.values[0].to_sym
    when :Vanity
      vanity(data)
    when :Boosters
      boosters(data)
    when :Birthdays
      birthdays(data)
    end
  end
end
