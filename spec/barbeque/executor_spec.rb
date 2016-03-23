describe Barbeque::Executor do
  describe '#run' do
    let(:job) { 'TestJob' }
    let(:args) { ['foo', 'bar'] }
    let(:executor) do
      Barbeque::Executor.new(job: job, message: JSON.dump(args))
    end
    let(:test_job) { double('TestJob') }

    before do
      allow(TestJob).to receive(:new).and_return(test_job)
    end

    it 'calls #perform of given job' do
      expect(test_job).to receive(:perform).with(*args)
      executor.run
    end
  end
end
