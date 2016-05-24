require 'sinatra/base'
require 'securerandom'
require 'json'

module Barbeque
  # Fake API to run job locally
  class Runner < Sinatra::Base
    set :port, ENV['PORT'] || 3003

    post '/v1/job_executions' do
      params = JSON.parse(request.body.read)
      spawn(
        'bundle', 'exec', 'rake', 'barbeque:execute',
        "BARBEQUE_JOB=#{params['job']}", "BARBEQUE_MESSAGE=#{params['message']}",
        "BARBEQUE_RETRY_COUNT=0",
      )

      content_type :json
      { status: 'pending', message_id: SecureRandom.uuid }.to_json
    end

    post '/v1/job_executions/:message_id/retries' do
      # TODO: Implement caching message and retry it
      puts "Received retry: #{params['message_id']} (retry skipped)"

      content_type :json
      { status: 'pending', message_id: SecureRandom.uuid }.to_json
    end
  end
end
