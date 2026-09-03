module ServiceMonitoring
  def call(*args, **kwargs)
    @args = args
    @kwargs = kwargs
    @monitoring_end_status = Log::SUCCESSFUL

    pre_call_monitoring

    begin
      super(*args, **kwargs)
    rescue
      set_monitoring_end_status(end_status: Log::ERRORED)
      raise # make sure we don't swallow the exception
    ensure
      # TODO: save result of call to the log?
      post_call_monitoring
    end
  end

  def pre_call_monitoring
    @log_for_action = Log.new(
      action: self.class.to_s,
      parameters: {
        args: @args,
        kwargs: @kwargs
      },
      status: Log::ATTEMPTED
    )
    @log_for_action.save!

    # hook in Datadog or similar monitoring for for attempted calls
  end

  def post_call_monitoring
    @log_for_action.status = @monitoring_end_status
    @log_for_action.save!

    # hook in Datadog or similar monitoring for successful calls
  end

  def set_failed_validation_end_status
    set_monitoring_end_status(end_status: Log::FAILED_VALIDATION)
  end

  # if you want to change the end status of the call to the service, use set_monitoring_end_status
  # to change the log's status to "failed_validation", "errored", or whatever is appropriate
  def set_monitoring_end_status(end_status:)
    @monitoring_end_status = end_status
    # TODO: add field for status explanation? i.e. failed validation because there's already a line item for that variant on the invoice
  end

  # set a primary id and model name associate with the call, not mandatory
  # designed to allow SQL querying for Logs related to other models in the system
  # for example, CreateInvoiceService would set primary_id to the created invoice id and primary_model to Invoice
  def set_primary_model_and_id(primary_id:, primary_model:)
    # TODO: create migration to add these fields to Log and populate them
    # TODO: add secondary IDs and models in a JSON field? so a log for CreateLineItemService could store the invoice id and created line item id
    # secondary thought: make this method add_model_reference and just use the JSON fields?
  end
end
