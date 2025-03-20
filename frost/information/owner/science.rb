# frozen_string_literal: true

module Owner
  # Manage actions in the bot.
  def self.science(data)
    unless data.user.id == owner
      data.edit_response(content: RESPONSE[1])
      return
    end

    if data.options["dial"] == 1
      while (emoji = Frost::Emojis.drain.shift)
        Frost::Emojis.add(emoji[:emoji], emoji[:guild])
      end
    end

    data.bot.stop if data.options["dial"] == 2

    if data.options["dial"] == 3
      exec("bundle exec ruby --yjit core.rb")
    end

    if data.options["dial"] == 4
      data.show_modal(title: "Eval", custom_id: "|") do |view|
        view.row do |ui|
          ui.text_input(
            label: "Code",
            style: :paragraph,
            custom_id: "evaluate"
          )
        end
      end
    end

    return if data.options["dial"] == 3 || 4

    data.edit_response(content: RESPONSE[1])
  end
end
