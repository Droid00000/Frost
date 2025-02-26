# frozen_string_literal: true

require "tzinfo"
require "discordrb"
require "tzinfo/data"

# Mappings.
array = []

$number = 1

def id_object
  var = Discordrb::IDObject.synthesize(Time.now + $number)

  $number += 1

  return var
end

# The time zone database source.
TZInfo::DataSource.set(:zoneinfo)

# Iteration for the typesense database.
TZInfo::Country.all.each do |country|
  next if country.name == "Antarctica"

  timezones = country.zone_names.reject do |zone|
    zone.include?("Antarctica")
  end

  resolved = timezones.map do |zone|
    split = zone.split("/").last.gsub("_", " ")

    procces = if split == country.name
                "#{country.name}"
              else
                "#{split}, #{country.name}"
              end

    { name: procces, value: zone }
  end

 resolved.each do |co|
  array << {
    _snowflake: id_object,
    name: co[:name],
    value: co [:value],
    country: country.name,
    resolved: co
  }
end
end

array_to_return = []

# Upload to the typesense database.
array.compact.each do |payload|
  unless payload[:resolved].empty? && payload[:timezones].empty?
    array_to_return << payload
  end
end

File.open('out.json', 'w') do |f|
  f.write(array_to_return.to_json)
end
