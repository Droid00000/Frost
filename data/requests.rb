# frozen_string_literal: true

require 'json'
require 'discordrb'
require_relative 'schema'
require_relative 'constants'

module Frigid
  module Requests
    module_function
    # API call for updating a booster role.
    def booster_roles(user_id, server_id, color: nil, name: nil, icon: nil)
      Discordrb::API.request(
        :guilds_sid_roles_rid,
        server_id,
        :patch,
        "#{Discordrb::API.api_base}/guilds/#{server_id}/roles/#{booster_records(server: server_id, user: user_id, type: :get_role)}",
        { color: color_data, name: name, icon: image_string }.compact.to_json,
        Authorization: TOML['Discord']['TOKEN'],
        content_type: :json,
        'X-Audit-Log-Reason': REASON[2]
      )
    end

    # API call for updating an event role.
    def event_roles(role, color: nil, name: nil, icon: nil)
      Discordrb::API.request(
        :guilds_sid_roles_rid,
        server_id,
        :patch,
        "#{Discordrb::API.api_base}/guilds/#{server_id}/roles/#{role}",
        { color: color_data, name: name, icon: image_string }.compact.to_json,
        Authorization: TOML['Discord']['TOKEN'],
        content_type: :json,
        'X-Audit-Log-Reason': REASON[5]
      )
    end

    # API call for deleting a booster role.
    def delete_role(server_id, user_id)
      Discordrb::API.request(
        :guilds_sid_roles_rid,
        server_id,
        :delete,
        "#{Discordrb::API.api_base}/guilds/#{server_id}/roles/#{booster_records(server: server_id, user: user_id, type: :get_role)}",
        Authorization: TOML['Discord']['TOKEN'],
        'X-Audit-Log-Reason': REASON[3]
      )
    end

    # API call for checking a member's boosting status.
    def booster_status(server_id, user_id)
      !JSON.parse(Discordrb::API.request(
      :users_sid,
      :user_id,
      :get,
      "#{Discordrb::API.api_base}/guilds/#{server_id}/members/#{user_id}",
      Authorization: TOML['Discord']['TOKEN']
    ))['premium_since'].nil?
    rescue StandardError
      false
    end

    # API call for updating a channel name.
    def update_channel(name)
      Discordrb::API.request(
        :channels_cid,
        :channel_id,
        :patch,
        "#{Discordrb::API.api_base}/channels/#{TOML['Chapter']['CHANNEL']}",
        { name: name }.compact.to_json,
        Authorization: TOML['Discord']['TOKEN'],
        content_type: :json,
        'X-Audit-Log-Reason': REASON[4]
      )
    end
  end
end
