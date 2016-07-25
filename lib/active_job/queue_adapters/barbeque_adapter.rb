module ActiveJob
  module QueueAdapters
    class BarbequeAdapter
      # Interface for ActiveJob 5.0
      def enqueue(job)
        BarbequeAdapter.enqueue(job)
      end

      class << self
        # Interface for ActiveJob 4.2
        def enqueue(job)
          execution = BarbequeClient.enqueue(
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
