require 'garage_client'
require 'json'

module Barbeque
  class Client
    def initialize(application:, default_queue:, endpoint:)
      @application   = application
      @default_queue = default_queue
      @endpoint      = endpoint
    end

    # @param [String] job     - Job name to enqueue.
    # @param [Object] message - An object which is serializable as JSON.
    # @param optional [String] queue - A queue name to enqueue a job.
    # @param [Faraday::Response]
    def create_execution(job:, message:, queue: nil)
      params = {
        application: @application,
        job:         job,
        message:     message.to_json,
        queue:       queue || @default_queue,
      }
      result = garage_client.post('/v1/job_executions', params)
      result.response
    end

    # @param [String] message_id - Job execution's message_id to check status
    # @param [Faraday::Response]
    def execution(message_id:)
      result = garage_client.get("/v1/job_executions/#{message_id}")
      result.response
    end

    private

    def garage_client
      @garage_client ||= GarageClient::Client.new(
        endpoint:    @endpoint,
        path_prefix: '/v1',
      )
    end
  end
end
