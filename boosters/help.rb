# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require 'discordrb'

def help_embed(data)
  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = '**Booster Commands**'
      embed.colour = UI[25]
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[21])
      embed.add_field(name: '``/booster role claim``', value: 'Creates your custom role. Your role name must contain any foul language. Simply put a custom emoji as you normally would in the icon option.')
      embed.add_field(name: '``/booster role edit``', value: 'Lets you edit your custom role. All parameters are optional.')
      embed.add_field(name: '``/booster role delete``', value: 'Deletes your custom role. You can make a new role at any time provided you keep boosting the server.')
      embed.add_field(name: '``/booster role setup``', value: 'Sets up the bot for use on your server.')
      embed.add_field(name: '``/booster role help``', value: 'Shows some info on how to use the bot.')
      embed.add_field(name: '``/help``', value: 'Opens the general help menu.')
    end
  end
end
