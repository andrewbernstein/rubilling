class Promotions::CreatePromotionService
  prepend ServiceMonitoring

  class InvalidPromotionError < StandardError; end

  def initialize(variant:, amount_in_cents: 0, percentage: 0, description: "", start_at: DateTime.now, end_at: nil)
    @variant = variant
    @amount_in_cents = amount_in_cents
    @percentage = percentage
    @description = description
    @start_at = start_at
    @end_at = end_at
  end

  def call
    validation_result = validate_parameters
    return validation_result if validation_result.failure?

    promotion = Promotion.new(
      variant: @variant,
      amount_in_cents: @amount_in_cents,
      percentage: @percentage,
      description: @description,
      start_at: @start_at,
      end_at: @end_at
    )
    promotion.save!

    result = ServiceResult.new
    result[:promotion] = promotion
    result.success!

    result
  end

  def validate_parameters
    result = ServiceResult.new

    if @amount_in_cents.blank? || @percentage.blank?
      result.error!("Must have either amount_in_cents or percentage when creating a promotion")
    end

    if @amount_in_cents.present? && @percentage.peresent?
      result.error!("Cannot have amount_in_cents and percentage present when creating a promotion")
    end

    if @start_at.blank?
      result.error!("Must have start_at when creating a promotion")
    end

    if result.failure?
      set_failed_validation_end_status
      return result
    end

    result.success!
    result
  end
end
