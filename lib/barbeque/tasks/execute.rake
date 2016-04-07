namespace :barbeque do
  desc 'Execute ActiveJob task with barbeque envs'
  task execute: :environment do
    executor = Barbeque::Executor.new(
      job:     ENV['BARBEQUE_JOB'],
      message: ENV['BARBEQUE_MESSAGE'],
    )
    executor.run
  end

  desc 'Start a fake barbeque API for development'
  task :runner do
    require 'barbeque/runner'
    Barbeque::Runner.run!
  end
end
