class ServiceResult
  class AlreadyMarkedSuccessError < StandardError; end
  class AlreadyMarkedFailureError < StandardError; end
  class IndeterminateResultError < StandardError; end

  def initialize
    @results = {
      success: "indeterminate"
    }
    @errors = []
  end

  def errors
    @errors
  end

  def results
    @results
  end

  def error!(error)
    @errors << error
    failure!
  end

  def success?
    @errors.none? && @results[:success] == true
  end

  def success!
    raise AlreadyMarkedFailureError if @results[:success] == false
    @results[:success] = true
  end

  def failure?
    @errors.any? || @results[:success] == false
  end

  def failure!
    raise AlreadyMarkedSuccessError if @results[:success] == true
    @results[:success] = false
  end
end
