require 'barbeque/configuration'
require 'barbeque/client'
require 'barbeque/version'
require 'barbeque/railtie'

module Barbeque
  class << self
    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    # @param  [String] job     - Job name to enqueue.
    # @param  [Object] message - An object which is serializable as JSON.
    # @param  optional [String] queue - A queue name to enqueue a job.
    # @param  optional [String] environment - Optional meta data.
    # @return [Hashie::Mash] resonse - { id: Integer, status: String }
    def enqueue(job:, message:, queue: nil, environment: nil)
      response = client.create_execution(
        job:         job,
        message:     message,
        queue:       queue,
        environment: environment,
      )
      response.body
    end

    # @param  [Integer] id     - Job execution's id to check status
    # @return [String]  status - Job execution's status like "success", "pending", "failure", ...
    def status(id:)
      response = client.execution(id: id)
      response.body.status
    end

    private

    def client
      @client ||= Client.new(
        application:   config.application,
        default_queue: config.default_queue,
        endpoint:      config.endpoint,
      )
    end
  end
end
