# frozen_string_literal: true

module Owner
  # Manage actions in the bot.
  def self.science(data)
    unless data.user.id == CONFIG[:Discord][:OWNER]&.to_i
      data.edit_response(content: RESPONSE[1], ephemeral: true)
      return
    end

    # If we need to show a modal, we can't defer here.
    event.defer(ephemeral: true) if data.options["dial"] != 3

    case data.options["dial"]
    when 2
      data.bot.stop
    when 1
      Emojis::Storage.drain
    when 4
      exec("bundle exec ruby --yjit core.rb")
    when 5
      data.user.send_file(File.open("logs.txt", "r"))
    when 3
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

    return if data.options["dial"] == 3 || 4

    data.edit_response(content: RESPONSE[3])
  end
end
