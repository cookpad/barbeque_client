module ActiveJob
  module QueueAdapters
    class BarbequeAdapter
      class << self
        def enqueue(job)
          execution = Barbeque.enqueue(
            job:     job.class.to_s,
            message: ActiveJob::Arguments.serialize(job.arguments),
            queue:   job.queue_name,
          )
          job.job_id = execution.message_id
        end

        def enqueue_at(job, timestamp)
          raise NotImplementedError.new(
            'Currently setting timestamp is not supported'
          )
        end
      end
    end
  end
end
