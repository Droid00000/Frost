# frozen_string_literal: true

module Settings
  # Responses and fields for setting commands.
  RESPONSE = {
    1 => "Hi! Welcome to my help page. Use the dropdown menu below to view a category.\n\n**About Me**\nI was made by droid00000. My code is open source and can be viewed [here!](https://github.com/Droid00000/Frost)\n\n",
    2 => "These are the booster settings for your server. Server boosters can be added, removed, banned, and unbanned with the **/booster admin** command group.",
    3 => "These are the birthday settings for your server. Birthday perks can be enabled, edited, and disabled with the **/birthday admin** command group.",
    4 => "**Icon**\nServer boosters may only use server and unicode emojis as their role icon.",
    5 => "**Icon**\nServer boosters may use any custom or unicode emoji as their role icon.",
    6 => "**Manager**\nBirthday perks were enabled in this server by **%s** on <t:%s:D>\n\n",
    7 => "**Hoist Role**\nAll newly created roles will be moved above this role: <@&%s>\n\n",
    8 => "**Birthday Role**\nMembers will be given this role on their birthday: <@&%s>\n\n",
    9 => "**Manager**\nBooster perks were enabled in this server by **%s** on <t:%s:D>\n\n",
    10 => "**Channel**\nMembers will have their birthdays announced in this channel: <#%s>",
    11 => "**Stats**\nI'm on %s servers with a total of %s members and %s channels.",
    12 => "This feature has not been enabled.",
    13 => "### Birthday Perks for %s",
    14 => "### Booster Perks for %s",
    15 => "### Main Menu"
  }.freeze

  # Resolve the select menu.
  def self.menu(data)
    case data.values[0].to_sym
    when :Boosters
      boosters(data)
    when :Birthdays
      birthdays(data)
    end
  end
end
