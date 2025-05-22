# frozen_string_literal: true

module Owner
  # Manage actions in the bot.
  def self.science(data)
    unless data.user.id == CONFIG[:Discord][:OWNER]&.to_i
      data.respond(content: RESPONSE[1], ephemeral: true)
      return
    end

    # If we need to show a modal, we can't defer here.
    data.defer(ephemeral: true) if data.options["dial"] != 3

    if data.options["dial"] == 2
      data.edit_response(content: "Exiting!")
    elsif data.options["dial"] == 4
      data.edit_response(content: "Restarting!")
    elsif data.options["dial"] == 1
      data.edit_response(content: "Draining emojis!")
    elsif data.options["dial"] == 5
      data.edit_response(attachments: [File.open("logs.txt")])
    end

    if data.options["dial"] == 2
      exit
    elsif data.options["dial"] == 1
      Emojis::Storage.drain
    elsif data.options["dial"] == 4
      exec("bundle exec ruby --yjit core.rb")
    else
      data.show_modal(title: "Eval", custom_id: "3") do |view|
        view.row { it.text_input(label: "Code", style: 2, custom_id: "code") }
      end
    end
  end
end
