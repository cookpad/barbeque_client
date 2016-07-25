require 'json'

module BarbequeClient
  class Executor
    # @param [String] job - Job class name
    # @param [String] message - JSON-serialized object
    # @param [String] message_id - SQS mesasge_id
    # @param [String] queue_name - barbeque's job_queues.name
    def initialize(job:, message:, message_id:, queue_name:)
      @job        = job
      @message    = JSON.load(message)
      @message_id = message_id
      @queue_name = queue_name
    end

    def run
      ActiveJob::Base.execute(
        'job_class'  => @job,
        'job_id'     => @message_id,
        'queue_name' => @queue_name,
        'arguments'  => @message,
      )
    end
  end
end
