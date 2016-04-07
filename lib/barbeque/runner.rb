require 'sinatra'
require 'securerandom'
require 'json'

module Barbeque
  # Fake API to run job locally
  class Runner < Sinatra::Base
    post '/v1/job_executions' do
      params = JSON.parse(request.body.read)
      spawn(
        'bundle', 'exec', 'rake', 'barbeque:execute',
        "BARBEQUE_JOB=#{params['job']}", "BARBEQUE_MESSAGE=#{params['message']}",
      )

      content_type :json
      { status: 'pending', message_id: SecureRandom.uuid }.to_json
    end
  end
end
