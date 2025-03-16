# frozen_string_literal: true

module Owner
  # Manage actions in the bot.
  def self.science(data)
    unless data.user.id == CONFIG[:Discord][:OWNER]&.to_i
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

    data.edit_response(content: RESPONSE[1])
  end
end
