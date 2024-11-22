# frozen_string_literal: true

# Manually adds a user to the database.
def admin_add_booster(data)
  if booster_records(server: data.server.id, user: data.options['user'], type: :check_user)
    data.edit_response(content: RESPONSE[25])
    return
  end

  booster_records(server: data.server.id, user: data.options['user'], role: data.options['role'], type: :create)
  data.edit_response(content: "#{RESPONSE[26]} <@#{data.options['user']}>")
end

# Manually removes a user from the database.
def admin_remove_user(data)
  unless booster_records(server: data.server.id, user: data.options['user'], type: :check_user)
    data.edit_response(content: RESPONSE[27])
    return
  end

  booster_records(server: data.server.id, user: data.options['user'], type: :delete)
  data.edit_response(content: "#{RESPONSE[28]} <@#{data.options['user']}>")
end

# Blacklists a user from using booster perks in a server.
def admin_blacklist_user(data)
  if booster_records(server: data.server.id, user: data.options['user'], type: :banned)
    data.edit_response(content: RESPONSE[29])
    return
  end

  booster_records(server: data.server.id, user: data.options['user'], type: :ban)
  data.edit_response(content: "#{RESPONSE[30]} <@#{data.options['user']}>")
end

# Un-blacklists a user from using booster perks in a server.
def admin_remove_blacklist(data)
  unless booster_records(server: data.server.id, user: data.options['user'], type: :banned)
    data.edit_response(content: RESPONSE[31])
    return
  end

  booster_records(server: data.server.id, user: data.options['user'], type: :unban)
  data.edit_response(content: "#{RESPONSE[32]} <@#{data.options['user']}>")
end

# Setup booster perks for a server, or update them.
def admin_setup_perks(data)
  if booster_records(server: data.server.id, type: :enabled)
    booster_records(server: data.server.id, role: data.options['role'], type: :update_hoist_role)
    data.edit_response(content: "#{RESPONSE[33]} <@&#{data.options['role']}>")
    return
  end

  booster_records(server: data.server.id, role: data.options['role'], type: :setup)
  data.edit_response(content: "#{RESPONSE[33]} <@&#{data.options['role']}>")
end

# Disable booster perks for a server.
def admin_disable_perks(data)
  unless booster_records(server: data.server.id, type: :enabled)
    data.edit_response(content: RESPONSE[34])
    return
  end

  booster_records(server: data.server.id, type: :disable)
  data.edit_response(content: RESPONSE[35])
end
