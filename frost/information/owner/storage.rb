# frozen_string_literal: true

module Owner
  # Represents a commands DB.
  class Storage
    # Easy way to access the DB.
    @@pg = POSTGRES[:command_stats]

    # Easy way to access commands.
    @@commands = Hash.new { |hash, key| hash[key] = [] }

    # Insert a set of new commands into the DB.
    def self.drain
      POSTGRES.transaction do
        # Generate a single array for insertion.
        commands = @@commands.dup.map do |key, values|
          # Create the final hash for this record.
          final = {
            command_name: key,
            command_users: [],
            command_epochs: [],
            command_channels: []
          }

          # Loop over all of the stored records and append them.
          values.each do |value|
            final[:command_users].push(value[:command_user])
            final[:command_epochs].push(value[:command_epoch])
            final[:command_channels].push(value[:command_channel])
          end

          # Convert the arrays in the final hash to sequel arrays.
          final.transform_values do |value|
            value.is_a?(Array) ? Sequel.pg_array(value) : value.to_s
          end
        end

        # If there's nothing to drain, just return early.
        return unless commands.any?

        @@commands.clear if @@pg.insert_conflict(
          target: :command_name,
          update: {
            command_users: Sequel.lit("command_stats.command_users || EXCLUDED.command_users"),
            command_epochs: Sequel.lit("command_stats.command_epochs || EXCLUDED.command_epochs"),
            command_channels: Sequel.lit("command_stats.command_channels || EXCLUDED.command_channels")
          }
        ).multi_insert(commands)
      end
    end

    # Add a command to the local cache.
    def self.add(command)
      return unless command[:name].to_sym != :science

      @@commands[command[:name].to_sym] << command.except(:name)
    end
  end
end
