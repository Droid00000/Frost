# frozen_string_literal: true

module Emojis
  # make select menu.
  def self.menu(data)
    unless data.target.emoji?
      data.edit_response(content: RESPONSE[6])
      return
    end

    data.send_message do |_, components|
      components.row do |row|
        row.select_menu(custom_id: "emoji", placeholder: RESPONSE[8], min_values: 1) do |menu|
          data.target.emoji.uniq.first(25).each do |emoji|
            menu.option(label: emoji.name, value: emoji.mention, emoji: emoji.id)
          end
        end
      end
    end
  end
end
