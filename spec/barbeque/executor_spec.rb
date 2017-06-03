describe BarbequeClient::Executor do
  describe '#run' do
    let(:job) { 'TestJob' }
    let(:message_id) { SecureRandom.uuid }
    let(:args) { ['foo', 'bar'] }
    let(:queue_name) { 'blog' }
    let(:executor) do
      BarbequeClient::Executor.new(
        job:        job,
        message:    JSON.dump(args),
        message_id: message_id,
        queue_name: queue_name,
      )
    end
    let(:test_job) { TestJob.new }

    before do
      allow(TestJob).to receive(:new).and_return(test_job)
    end

    it 'performs a job' do
      expect(test_job).to receive(:perform).with(*args)
      executor.run

      expect(test_job.job_id).to eq(message_id)
      expect(test_job.queue_name).to eq(queue_name)
    end

    context 'with non-Array args like Notification message' do
      let(:args) { { 'foo' => 'bar' } }
      it 'performs a job' do
        expect(test_job).to receive(:perform).with('foo' => 'bar')
        executor.run

        expect(test_job.job_id).to eq(message_id)
        expect(test_job.queue_name).to eq(queue_name)
      end
    end
  end
end
