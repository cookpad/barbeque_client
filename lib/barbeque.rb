require 'barbeque/configuration'
require 'barbeque/client'
require 'barbeque/version'
require 'barbeque/executor'

begin
  require 'rails'
rescue LoadError
else
  require 'barbeque/railtie'
end

module BarbequeClient
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
    # @return [Hashie::Mash] resonse - { message_id: String, status: String }
    def enqueue(job:, message:, queue: nil)
      response = client.create_execution(
        job:     job,
        message: message,
        queue:   queue,
      )
      response.body
    end

    # @param  [String] message_id - Job execution's message_id to check status
    # @return [String] status     - Job execution's status like "success", "pending", "failure", ...
    def status(message_id:)
      response = client.execution(message_id: message_id)
      response.body.status
    end

    def client
      @client ||= Client.new(
        application:   config.application,
        default_queue: config.default_queue,
        endpoint:      config.endpoint,
      )
    end
  end
end
