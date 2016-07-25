$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'barbeque_client'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('./dummy/config/environment', __dir__)
require 'rspec/rails'

RSpec.configure do |config|
  config.around do |e|
    begin
      original_env = ENV.to_h.dup
      e.run
    ensure
      ENV.replace(original_env)
    end
  end
end
