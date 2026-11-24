# frozen_string_literal: true

module Boosters
  # Configure the booster perks feature.
  def self.booster_admin_configure(event)
    unless event.user.can_manage_roles?
      event.edit_response(content: REPLY.USER_MISSING_CONFIGURE_PERMISSIONS)
      return
    end

    settings = BOT.boosters_cache.fetch_guild(event.guild_id)
    external_icons_default = settings ? settings.any_icon? : true
    gradient_colors_default = settings ? !settings.no_gradient? : true
    role_default = settings && event.guild.role(settings.role_id) ? [settings.role_id] : nil

    event.show_modal(title: "Settings", custom_id: "booster_settings") do |ui|
      ui.label(label: "Role", description: "The role that all booster roles should be moved above.") do |label|
        label.role_select(
          max_values: 1,
          required: true,
          custom_id: "role_picker",
          default_values: role_default
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

  # Update the configuration for a guild.
  def self.configure_submission(event)
    unless event.user.can_manage_roles?
      event.edit_response(content: REPLY.USER_MISSING_CONFIGURE_PERMISSIONS)
      return
    end

    roles = event.get_component("role_picker")
    selected_role = event.guild.role(roles.values.first)

    features = event.get_component("features")
    external_icons = features.values.include?("external_icons")
    gradient_colors = features.values.include?("gradient_colors")

    flags = external_icons ? Boosters::Guild::FEATURES[:any_icon] : 0
    (flags |= Boosters::Guild::FEATURES[:no_gradient]) unless gradient_colors

    if selected_role > event.user.top_role && !event.user.owner?
      event.edit_response(content: REPLY.USER_MAX_ROLE_BELOW_CONFIGURE_TARGET)
      return
    end

    BOT.boosters_cache.create_guild(
      features: flags,
      id: event.guild_id,
      role: selected_role,
      setup_by: event.user
    )

    event.edit_response(content: REPLY.CONFIGURE_SUCCESS)
  end

  # Disable the booster perks feature.
  def self.booster_admin_disable(event)
    unless event.user.can_manage_roles?
      event.edit_response(content: REPLY.USER_MISSING_CONFIGURE_PERMISSIONS)
      return
    end

    result = BOT.boosters_cache.delete_guild(event.guild_id)

    if result.nil?
      event.edit_response(content: DELETE_CONFIGURE_SUCCESS)
    else
      event.edit_response(content: GUILD_UNCONFIGURED)
    end
  end

  # Manually remove a booster.
  def self.booster_admin_delete(event)
    unless event.user.can_manage_roles?
      event.edit_response(content: REPLY.USER_MISSING_CONFIGURE_PERMISSIONS)
      return
    end

    unless (settings = BOT.boosters_cache.fetch_guild(event.guild_id))
      event.edit_response(content: REPLY.GUILD_UNCONFIGURED)
      return
    end

    user_id = event.options[:target].to_i

    unless (booster = settings.fetch_booster(user_id))
      event.edit_response(content: REPLY.BOOSTER_ADMIN_DELETE_FAILURE)
      return
    end

    if booster && event.options[:prune]
      role = event.guild.role(booster.role_id)
      bot_max = event.guild.current_bot.top_role

      if role && (role < event.user.top_role) && (role < bot_max)
        role.delete(
          reason: "Booster Roles (Moderator: #{event.user.id})"
        )
      end
    end

    if settings.delete_booster(id: user_id)
      event.edit_response(content: REPLY.BOOSTER_ADMIN_DELETE_SUCCESS)
    else
      event.edit_response(content: REPLY.BOOSTER_ADMIN_DELETE_FAILURE)
    end
  end
end
