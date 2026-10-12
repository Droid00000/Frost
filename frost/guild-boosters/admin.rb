# frozen_string_literal: true

module Boosters
  # Configure the booster perks feature.
  def self.booster_admin_configure(event)
    unless event.user.can_manage_roles?
      event.edit_response(content: REPLY.USER_MISSING_CONFIGURE_PERMISSIONS)
      return
    end

    settings = BOT.boosters_cache.fetch_guild(event.guild_id)
    role_default = settings ? [settings.role_id] : nil
    external_icons_default = settings ? settings.any_icon? : true
    gradient_colors_default = settings ? !settings.no_gradient? : true

    event.show_modal(title: "Settings", custom_id: "booster_settings") do |ui|
      ui.label(label: "Role", description: "The role that all booster roles should be moved above.") do |label|
        label.role_select(
          max_values: 1,
          required: true,
          default_values: role_default,
          custom_id: "role_#{role_default&.first || 0}"
        )
      end

      ui.label(label: "Features") do |label|
        label.checkbox_group(custom_id: "features", required: false) do |group|
          group.checkbox(
            label: "External Icons",
            value: "external_icons",
            default: external_icons_default,
            description: "If external emojis can be used as role icons."
          )

          group.checkbox(
            label: "Gradient Colors",
            value: "gradient_colors",
            default: gradient_colors_default,
            description: "If booster roles can have enhanced role colors."
          )
        end
      end
    end
  end
end
