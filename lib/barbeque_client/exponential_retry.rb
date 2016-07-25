module BarbequeClient
  class ExponentialRetry
    MAX_DELAY_SECONDS = (ENV['BARBEQUE_MAX_RETRY_DELAY'] || 900).to_i

    # https://github.com/mperham/sidekiq/blob/v4.1.2/lib/sidekiq/middleware/server/retry_jobs.rb#L176-L179
    # @return [Integer] seconds
    def self.exponential_backoff(count)
      (count ** 4) + 15 + (rand(30) * (count + 1))
    end

    # @param [Integer] count - Count of retry
    def initialize(count)
      @count = count
    end

    # @param [String] message_id
    def retry(message_id)
      BarbequeClient.client.retry_execution(
        message_id:    message_id,
        delay_seconds: [delay_seconds, MAX_DELAY_SECONDS].min,
      )
    end

    private

    def delay_seconds
      ExponentialRetry.exponential_backoff(@count)
    end
  end
end
