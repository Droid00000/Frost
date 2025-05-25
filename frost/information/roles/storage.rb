# frozen_string_literal: true

# A single role for event roles.
class Role
  # @return [Integer]
  attr_reader :guild
  alias guild_id guild

  # @return [Integer]
  attr_reader :role
  alias role_id role

  # @return [Boolean]
  attr_reader :any_icon
  alias any_icon? any_icon

  # @return [Dataset]
  @@pg = POSTGRES[:event_settings]

  # @!visibility private
  def initialize(data, lazy: false)
    @bot = data.bot
    @lazy = lazy == true
    @guild = data.server.id
    @model = find_role(data)
    @role_id = @model[:role_id]
    @any_icon = @model[:any_icon]
  end

  # Check if this role is nil, e.g. hasn't been setup.
  # @return [Boolean] Whether this role is nil or not.
  def blank? = role_id.nil?

  # Create a new record or update an existing record.
  # @param guild_id [Integer] ID of the guild this record is for.
  # @param role_id [Integer] ID of the role this record is for.
  # @param any_icon [Boolean] Whether this guild supports external role icons.
  def edit(**options)
    POSTGRES.transaction do
      @@pg.insert_conflict(**conflict(options)).insert(**options)
    end
  end

  # Delete the record for this role.
  # @note This method takes arguments, but currently they're ignored.
  def delete(**_options)
    POSTGRES.transaction { @@pg.where(guild_id: guild, role_id: role).delete }
  end

  private

  # @!visibility private
  def conflict(*options)
    { target: :role_id, update: { any_icon: options[0][:any_icon] } }
  end

  # @!visibility private
  def find_role(*options)
    @lazy ? {} : POSTGRES.transaction { @@pg.where(guild_id: options[0].options["role"]).first }
  end
end
