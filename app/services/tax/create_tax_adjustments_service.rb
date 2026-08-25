class Tax::CreateTaxAdjustmentsService
  prepend ServiceMonitoring

  # everything in this file is subject to change dependent on integration with at least one external tax service
  def initialize(adjustment_info:)
    # adjustment_info should be an array of hashes
    # where each hash has a line_item_id and at least an amount_in_cents
    # might need some sort of external tax identifier for committing taxes eventually?
    @adjustment_info = adjustment_info
  end

  def call
    @adjustment_info.each do |line_info|
      line_item = LineItem.find(line_info[:line_item_id])
      tax_adjustment_info = line_info[:tax_adjustment_info]

      tax_adjustment_info.each do |tax_adjustment|
        Adjustments::CreateTaxAdjustmentService.new(
          line_item: line_item,
          amount_in_cents: tax_adjustment[:amount_in_cents]
        ).call
      end
    end
  end
end
