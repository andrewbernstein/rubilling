class Entities::CreateEntityService
  prepend ServiceMonitoring

  def initialize(name:, external_id:)
    @name = name
    @external_id = external_id
  end

  def call
    entity = Entity.new(
      name: @name,
      external_id: @external_id
    )
    entity.save!

    entity
  end
end
