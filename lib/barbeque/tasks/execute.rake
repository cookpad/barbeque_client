namespace :barbeque do
  desc 'Execute ActiveJob task with barbeque envs'
  task execute: :environment do
    BarbequeClient::Executor.new(
      job:        ENV['BARBEQUE_JOB'],
      message:    ENV['BARBEQUE_MESSAGE'],
      message_id: ENV['BARBEQUE_MESSAGE_ID'],
      queue_name: ENV['BARBEQUE_QUEUE_NAME'],
    ).run
  end

  desc 'Start a fake barbeque API for development'
  task :runner do
    require 'barbeque/runner'
    BarbequeClient::Runner.run!
  end
end
