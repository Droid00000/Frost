# frozen_string_literal: true

module Frost::Overview
  # Event handler for the bot's owner menu.
  def self.owner_page(event)
    if event.user.id != BOT.config.owner_id
      event.send_message(content: REPLY.USER_NOT_BOT_OWNER, ephemeral: true)
      return
    end

    # EPHEMERAL and IS_COMPONENTS_V2 message flags.
    flags = (1 << 6) | (1 << 15)

    event.send_message(flags: flags) do |_, ui|
      # The entire response is wrapped in a container.
      ui.container do |container|
        container.text_display(content: "### Control Panel\n-# Welcome back Big Droid.")

        container.separator(spacing: :small, divider: true)

        container.section do |section|
          section.text_display(content: "**Restart**\n-# Restart the bot.")
          section.button(style: :primary, label: "Reboot", custom_id: "owner_page_restart")
        end

        container.separator(spacing: :small, divider: false)

        container.section do |section|
          section.text_display(content: "**Logging**\n-# View the bot's logfile.")
          section.button(style: :primary, label: "Viewer", custom_id: "owner_page_logging")
        end

        container.separator(spacing: :small, divider: false)

        container.section do |section|
          section.text_display(content: "**Evaluate**\n-# Run some Ruby code.")
          section.button(style: :primary, label: "Runner", custom_id: "owner_page_evaluate")
        end

        container.separator(spacing: :small, divider: true)

        events = Frost::Utilities.delimit(BOT.event_counter)

        container.section do |section|
          section.text_display(content: "**Gateway**\n-# Events Seen: #{events}\n-# Login Time: <t:#{BOT.ready_time}:d>\n")
          section.button(style: :danger, label: "Logout", custom_id: "owner_page_shutdown")
        end
      end
    end
  end

  # Event handler for the owner_page_restart button.
  def self.owner_page_restart(event)
    if event.user.id != BOT.config.owner_id
      event.send_message(
        content: REPLY.USER_NOT_BOT_OWNER, ephemeral: true
      )
      return
    end

    event.send_message(
      content: REPLY.PROCESS_RESTARTING_NOW, ephemeral: true
    )

    Kernel.exec("bundle exec ruby core.rb")
  end

  # Event handler for the owner_page_shutdown button.
  def self.owner_page_shutdown(event)
    if event.user.id != BOT.config.owner_id
      event.send_message(
        content: REPLY.USER_NOT_BOT_OWNER, ephemeral: true
      )
      return
    end

    event.send_message(
      content: REPLY.PROCESS_TERMINATING_NOW, ephemeral: true
    )

    Kernel.exit(0)
  end

  # Event handler for the owner_page_logging button.
  def self.owner_page_logging(event)
    if event.user.id != BOT.config.owner_id
      event.send_message(
        content: REPLY.USER_NOT_BOT_OWNER, ephemeral: true
      )
      return
    end

    event.send_message(
      attachments: [File.open("logs.rb", "rb")], ephemeral: true
    )
  end

  # Event handler for the owner_page_evaluate button.
  def self.owner_page_evaluate(event)
    if event.user.id != BOT.config.owner_id
      event.send_message(
        content: REPLY.USER_NOT_BOT_OWNER, ephemeral: true
      )
      return
    end

    id = "owner_page_evaluate"

    event.show_modal(title: "Evaluate", custom_id: id) do |ui|
      ui.label(label: "Code") do |label|
        label.text_input(style: :paragraph, custom_id: "code")
      end
    end
  end

  # Event handler for the owner_page_evaluate modal.
  def self.evaluate_modal_submit(event)
    # Transform mobile smart quotes to normal quotes.
    (code = event.value("code")).gsub!(/[‘’“”]/, '"')

    begin
      # rubocop:disable Security/Eval
      code = eval(code)
      # rubocop:enable Security/Eval
    rescue StandardError, SyntaxError => e
      code = "#{e.backtrace.join("\n")}\n#{e.message}"
    end

    code = if (string = code.inspect).length > 100
             value = PP.pp(code, +"")
             bytes = StringIO.new(value, "rb")
             { file: bytes, filename: "output.rb" }
           else
             string
           end

    if code.is_a?(Hash)
      event.edit_response(attachments: [code])
    elsif code.to_s.empty?
      event.edit_response(content: REPLY.EVAL_NO_CONTENT)
    else
      event.edit_response(content: "```ruby\n#{code}\n```")
    end
  end
end
