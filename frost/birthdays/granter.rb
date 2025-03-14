# frozen_string_literal: true

module Birthdays
  # Add the birthday role to someone.
  def self.grant(data)
    # Check if the birthday perks are setup
    # in the guild we're currently calling from.
    unless Frost::Birthdays::Settings.role(data)
      data.edit_response(content: RESPONSE[104])
      return
    end

    # Initialize the member we're
    # doing birthday shit on here.
    member = data.member("member")

    # Add the role to the member.
    add_guild_role(data.server, member)

    # Send the birthday message if enabled.
    birthday_message(data.server, member)

    # Schedule the role for removal in a day.
    Rufus::Scheduler.new.in "24h" do
      remove_user_role(data.server, member)
    end

    data.edit_response(content: RESPONSE[3])
  end
end
