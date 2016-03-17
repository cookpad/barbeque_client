class TestJob < ActiveJob::Base
  queue_as :test_queue

  def perform(*args)
    # Do something later
  end
end
