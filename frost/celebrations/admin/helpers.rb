# frozen_string_literal: true

module Birthdays
  # Parse an IANA timezone given to use. This method is useful
  #  because it allows us to ignore case-sensitivity and whitespace.
  def self.timezone(options)
    # Sometimes we might get an interaction instead of a proper
    #  timezone string; handle this case appropriately here.
    if options.respond_to?(:options)
      options = options.options["timezone"]
    end

    options = options.split("/").map do |part|
      part.split(/[\s_]+/).map(&:capitalize).join("_")
    end

    TZInfo::Timezone.get(options.join("/")) rescue nil
  end

  # This is basically a pointless alias, but why not use it?
  singleton_class.alias_method :zone, :timezone

  # Construct a new date from the given options hash. This method
  #  is useful because it performs the validation for us and returns
  #  an error in the form of an atom, e.g. :err_error_name_goes_here.
  def self.create_datetime(options)
    timezone = timezone(options["timezone"])

    return :err_timezone_data if timezone.nil?

    return :err_datetime_data unless valid_datetime?(options)

    date = options.select { |key| %w[month day].include?(key) }

    timezone.local_to_utc(Time.new(Time.now.year, *date.values, 0, 0, 0))
  end

  # Check if a date given to us is valid, e.g. it isn't something
  #  like 02/30 which cannot occur. This has been seperated out into
  #  its own method since Ruby's standard {Time} class does not make
  #  sure that the date passed is actually a valid calender date.
  def self.valid_datetime?(options)
    return true if options.except("timezone").empty?

    Date.parse(options.except("timezone").values.join("/")) rescue false
  end
end
