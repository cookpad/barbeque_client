require 'barbeque/exponential_retry'

module Barbeque
  module Retryable
    extend ActiveSupport::Concern

    class EmptyRetryCount < StandardError; end

    module ClassMethods
      def barbeque_retry(limit:, retryable_exceptions: nil)
        exceptions = Array.wrap(retryable_exceptions || StandardError)

        rescue_from *exceptions do |exception|
          unless ENV['BARBEQUE_RETRY_COUNT']
            raise EmptyRetryCount.new('ENV["BARBEQUE_RETRY_COUNT"] is not set')
          end
          count = ENV['BARBEQUE_RETRY_COUNT'].to_i

          if count < limit
            ExponentialRetry.new(count).retry(self.job_id)
          else
            raise exception
          end
        end
      end
    end
  end
end
