class Entities::GetEntitiesService
  prepend ServiceMonitoring

  def initialize(per_page: nil, page: nil)
    @per_page = per_page
    @page = page
  end

  def call
    query = Entity
    query = query.limit(@per_page) if @per_page.present?
    query = query.offset(@per_page * @page)
    query
  end
end