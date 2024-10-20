require 'toml-rb'

CONFIG_WRITE = TomlRB.load_file('example.toml')

CONFIG_WRITE['owner']['name'] = "New Name"
CONFIG_WRITE['database']['connection_max'] = 6000
CONFIG_WRITE['database']['enabled'] = false

# Step 3: Write the modified data back to the TOML file
modified_toml_content = TomlRB.dump(existing_data)

File.open(file_path, 'w') do |file|
  file.write(modified_toml_content)
end

puts "Data updated in #{file_path}"

