require 'json'

module Barbeque
  class Executor
    # @param [String] job - Job class name
    # @param [String] message - JSON-serialized object
    def initialize(job:, message:)
      @job_class = job.constantize
      @message   = JSON.load(message)
    end

    def run
      @job_class.perform_now(*@message)
    end
  end
end
