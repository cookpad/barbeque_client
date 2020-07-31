require 'sinatra/base'
require 'securerandom'
require 'json'

module BarbequeClient
  # Fake API to run job locally
  class Runner < Sinatra::Base
    set :port, ENV['PORT'] || 3003

    class << self
      # global variable
      def messages
        @messages ||= {}
      end
    end

    post '/v1/job_executions' do
      params = JSON.parse(request.body.read)
      message_id = SecureRandom.uuid
      pid = spawn(
        'bundle', 'exec', 'rake', 'barbeque:execute',
        "BARBEQUE_MESSAGE_ID=#{message_id}",
        "BARBEQUE_JOB=#{params['job']}", "BARBEQUE_MESSAGE=#{params['message']}",
        "BARBEQUE_RETRY_COUNT=0",
      )
      Runner.messages[message_id] = Process.detach(pid)

      content_type :json
      { status: 'pending', message_id: message_id }.to_json
    end

    post '/v2/job_executions' do
      params = JSON.parse(request.body.read)
      message_id = SecureRandom.uuid
      pid = spawn(
        'bundle', 'exec', 'rake', 'barbeque:execute',
        "BARBEQUE_MESSAGE_ID=#{message_id}",
        "BARBEQUE_JOB=#{params['job']}", "BARBEQUE_MESSAGE=#{params['message'].to_json}",
        "BARBEQUE_RETRY_COUNT=0",
      )
      Runner.messages[message_id] = Process.detach(pid)

      content_type :json
      { status: 'pending', message_id: message_id }.to_json
    end

    get '/v1/job_executions/:message_id' do
      message_id = params['message_id']
      wait_thr = Runner.messages[message_id]

      status = if wait_thr.nil?
                 'pending'
               elsif wait_thr.alive?
                 'running'
               else
                 if wait_thr.value.exitstatus == 0
                   'success'
                 else
                   'failed'
                 end
               end

      content_type :json
      { status: status, message_id: message_id }.to_json
    end

    post '/v1/job_executions/:message_id/retries' do
      # TODO: Save message on "/v1/job_executions" and stop skipping retry.
      puts "Received retry: #{params['message_id']} (retry skipped)"

      content_type :json
      { status: 'pending', message_id: SecureRandom.uuid }.to_json
    end
  end
end
