# frozen_string_literal: true

module Owner
  # Manage actions in the bot.
  def self.science(data)
    unless data.user.id == CONFIG[:Discord][:OWNER]&.to_i
      data.respond(content: RESPONSE[2], ephemeral: true)
      return
    end

    # If we need to show a modal, we can't defer here.
    data.defer(ephemeral: true) if data.options["dial"] != 3

    case data.options["dial"]
    when 1
      data.edit_response(content: "Exiting!")
      exit
    when 2
      data.show_modal(title: "Eval", custom_id: "3") do |view|
        view.row { it.text_input(label: "Code", style: 2, custom_id: "code") }
      end
    when 3
      Owner.statistics(data)
    when 4
      data.edit_response(content: "Restarting!")
      exec("bundle exec ruby --yjit core.rb")
    when 5
      data.edit_response(attachments: [File.open("logs.rb")])
    end
  end
end
