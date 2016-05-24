class TestJob < ActiveJob::Base
  include Barbeque::Retryable

  queue_as :test_queue
  barbeque_retry limit: 1, retryable_exceptions: Timeout::Error

  def perform(*args)
    # Do something later
  end
end
