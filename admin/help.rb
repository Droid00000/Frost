# frozen_string_literal: true

require_relative '../data/constants'
require 'discordrb'

def general_help_embed(data)
  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = '**General Commands**'
      embed.colour = UI[25]
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[21])
      embed.add_field(name: "``/hug``", value: "Sends a random GIF to hug a server member.")
      embed.add_field(name: "``/nom``", value: "Sends a random GIF to nom a server member.")  
      embed.add_field(name: "``/poke``", value: "Sends a random GIF to poke a server member.")
      embed.add_field(name: "``/help``", value: "Opens the general help menu.")
      embed.add_field(name: "``/about``", value: "Shows some information about the bot.")  
      embed.add_field(name: "``/sleep``", value: "Sends a random GIF to tell a server member to go to sleep.")
      embed.add_field(name: "``/angered``", value: "Sends a random GIF to show your anger towards a server member.")
      embed.add_field(name: "``/shutdown``", value: "Allows the bot owner to shutdown the bot.")
      embed.add_field(name: "``/booster role help``", value: "Opens the booster perks help menu.")
      embed.add_field(name: "``/event roles setup``", value: "sets up the event roles functionality.")
      embed.add_field(name: "``/pin archiver setup``", value: "sets up the pin archiver.")
      embed.add_field(name: "``/boosting admin help``", value: "Opens the booster perks help menu in administrator mode.")
    end
  end
end
