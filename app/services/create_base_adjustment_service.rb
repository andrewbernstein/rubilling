class CreateBaseAdjustmentService
  prepend ServiceMonitoring

  def initialize(line_item:)
    @line_item = line_item
  end

  def call
    puts "CreateBaseAdjustmentService dummy call for now"
  end
end
