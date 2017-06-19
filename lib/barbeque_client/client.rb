require 'garage_client'
require 'json'

module BarbequeClient
  class Client
    def initialize(application:, default_queue:, endpoint:, tracing: {})
      @application   = application
      @default_queue = default_queue
      @endpoint      = endpoint
      @tracing       = tracing || {}
    end

    # @param [String] job     - Job name to enqueue.
    # @param [Object] message - An object which is serializable as JSON.
    # @param optional [String] queue - A queue name to enqueue a job.
    # @return [Faraday::Response]
    def create_execution(job:, message:, queue: nil)
      params = {
        application: @application,
        job:         job,
        message:     message,
        queue:       queue || @default_queue,
      }
      result = garage_client.post('/v2/job_executions', params)
      result.response
    end

    # @param [String] message_id     - Job execution's message_id to retry
    # @param [Integer] delay_seconds - Retry delay in seconds. Maximum is 900s.
    # @return [Faraday::Response]
    def retry_execution(message_id:, delay_seconds: 0)
      result = garage_client.post(
        "/v1/job_executions/#{message_id}/retries",
        delay_seconds: delay_seconds,
      )
      result.response
    end

    # @param [String] message_id - Job execution's message_id to check status
    # @param optioanl [String] fields - Response fields specification for Garage
    # @return [Faraday::Response]
    def execution(message_id:, fields: nil)
      params = {}
      if fields
        params[:fields] = fields
      end
      result = garage_client.get("/v1/job_executions/#{message_id}", params)
      result.response
    end

    private

    def garage_client
      @garage_client ||= GarageClient::Client.new(garage_client_option)
    end

    def garage_client_option
      option = { endpoint: @endpoint, path_prefix: '/' }
      option[:tracing] = @tracing if @tracing[:tracer]
      option
    end
  end
end
