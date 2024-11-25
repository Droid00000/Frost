# frozen_string_literal: true

def create_menu(data)
  unless data.target.emoji?
    data.edit_response(content: RESPONSE[42])
    return
  end

  data.send_message do |builder, components|
    components.row do |menu|
      menu.select_menu(custom_id: 'emojis', placeholder: EMBED[34], min_values: 1) do |options|
        data.target.emoji.each_with_index do |emoji, count|
          break if count > 24

          options.option(label: emoji.name, value: emoji.mention, emoji: emoji.id)
        end
      end
    end
  end
end
