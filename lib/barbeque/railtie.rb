begin
  require 'rails'
rescue LoadError
else
  ActiveSupport.on_load(:active_job) do
    require 'active_job/queue_adapters/barbeque_adapter'
  end
end
