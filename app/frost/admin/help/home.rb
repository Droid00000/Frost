# frozen_string_literal: true

def help_welcome(data)
  data.send_message do |builder, components|
    components.row do |menu|
      menu.select_menu(custom_id: 'help', placeholder: EMBED[65], min_values: 1) do |options|
        options.option(label: EMBED[57], value: EMBED[57], description: EMBED[61], emoji: 1320928322804388003)
        options.option(label: EMBED[58], value: EMBED[58], description: EMBED[62], emoji: 1320928568187818025)
        options.option(label: EMBED[60], value: EMBED[60], description: EMBED[64], emoji: 1320933556645793822)
        options.option(label: EMBED[59], value: EMBED[59], description: EMBED[63], emoji: 1320929329307324497)
      end
    end
  end
end
