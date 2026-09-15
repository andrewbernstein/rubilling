class ServiceResult
  class AlreadyMarkedSuccessError < StandardError; end
  class AlreadyMarkedFailureError < StandardError; end
  class IndeterminateResultError < StandardError; end

  def initialize(**kwargs)
    @results = kwargs || {}
    @results[:success] = "indeterminate"
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
    self
  end

  def failure?
    @errors.any? || @results[:success] == false
  end

  def failure!
    raise AlreadyMarkedSuccessError if @results[:success] == true
    @results[:success] = false
    self
  end

  def method_missing(name, *args, **kwargs, &block)
    if @results[name].present? || @results[name] == false
      return @results[name]
    end

    string_name = name.to_s
    if string_name.last == "="
      key_to_set = string_name[0..-2] # not entirely sure why you need -2 here...
      @results[key_to_set.to_sym] = args[0]
      return
    end

    super
  end
end
