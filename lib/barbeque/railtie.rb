ActiveSupport.on_load(:active_job) do
  require 'active_job/queue_adapters/barbeque_adapter'
end

module Barbeque
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'barbeque/tasks/execute.rake'
    end
  end
end
