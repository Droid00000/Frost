# frozen_string_literal: true

module Owner
  # Manage actions in the bot.
  def self.science(data)
    unless data.user.id == CONFIG[:Discord][:OWNER]&.to_i
      data.edit_response(content: RESPONSE[1], ephemeral: true)
      return
    end

    event.defer(ephemeral: true) if data.options["dial"] != 3

    Emojis::Storage.drain if data.options["dial"] == 1

    data.bot.stop if data.options["dial"] == 2

    if data.options["dial"] == 4
      data.edit_response(content: RESPONSE[4])
      exec("bundle exec ruby --yjit core.rb")
    end

    if data.options["dial"] == 3
      data.show_modal(title: "Eval", custom_id: "3") do |view|
        view.row do |ui|
          ui.text_input(
            label: "Code",
            style: :paragraph,
            custom_id: "code"
          )
        end
      end
    end

    if data.options["dial"] == 5
      me = data.bot.user(CONFIG[:Discord][:OWNER])
      me.send_file(File.open("logs.txt", "r"))
    end

    return if data.options["dial"] == 3 || 4

    data.edit_response(content: RESPONSE[1])
  end
end
