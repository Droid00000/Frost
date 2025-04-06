# frozen_string_literal: true

module Emojis
  # make select menu.
  def self.menu(data)
    unless data.target.emoji?
      data.edit_response(content: RESPONSE[42])
      return
    end

    data.send_message do |_, components|
      components.row do |row|
        row.select_menu(custom_id: "emoji", placeholder: RESPONSE[1], min_values: 1) do |menu|
          data.target.emoji.uniq.each_with_index do |emoji, count|
            break if count > 24

            menu.option(label: emoji.name, value: emoji.mention, emoji: emoji.id)
          end
        end
      end
    end
  end
end
