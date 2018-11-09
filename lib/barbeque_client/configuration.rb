module BarbequeClient
  class Configuration
    def initialize
      @default_queue = 'default'
    end

    attr_accessor *%i[
      application
      default_queue
      endpoint
      tracing
      headers
    ]
  end
end
