require 'barbeque/configuration'
require 'barbeque/version'

module Barbeque
  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield config if block_given?
  end
end
