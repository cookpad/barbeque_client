$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'barbeque'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('./dummy/config/environment', __dir__)
require 'rspec/rails'
