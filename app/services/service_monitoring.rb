module ServiceMonitoring
  def call(*args, **kwargs)
    @args = args
    @kwargs = kwargs

    pre_call_monitoring

    super(*args, **kwargs)

    post_call_monitoring
  end

  def pre_call_monitoring
    @log_for_action = Log.new(
      action: self.class.to_s,
      parameters: {
        args: @args,
        kwargs: @kwargs
      },
      status: "attempted" # TODO: convert to enum on Log model
    )

    # hook in Datadog or similar monitoring for for attempted calls
  end

  def post_call_monitoring
    @log_for_action.status = "successful"
    @log_for_action.save!

    # hook in Datadog or similar monitoring for successful calls
  end
end
