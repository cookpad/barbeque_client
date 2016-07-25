ActiveSupport.on_load(:active_job) do
  require 'active_job/queue_adapters/barbeque_adapter'
  require 'barbeque_client/retryable'
end

module BarbequeClient
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'barbeque_client/tasks/execute.rake'
    end
  end
end
