module ActiveJob
  module QueueAdapters
    class BarbequeAdapter < ActiveJob::QueueAdapters::AbstractAdapter
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
