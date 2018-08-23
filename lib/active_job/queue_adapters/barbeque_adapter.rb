module ActiveJob
  module QueueAdapters
    class BarbequeAdapter
      # Interface for ActiveJob 5.0
      def enqueue(job)
        BarbequeAdapter.enqueue(job)
      end

      def enqueue_at(job, timestamp)
        BarbequeAdapter.enqueue_at(job, timestamp)
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
          delay_seconds = (timestamp - Time.now.to_f).round
          execution = BarbequeClient.enqueue(
            job:     job.class.to_s,
            message: ActiveJob::Arguments.serialize(job.arguments),
            queue:   job.queue_name,
            delay_seconds: delay_seconds,
          )
          job.job_id = execution.message_id
        end
      end
    end
  end
end
