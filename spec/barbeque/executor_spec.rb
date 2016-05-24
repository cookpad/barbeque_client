describe Barbeque::Executor do
  describe '#run' do
    let(:job) { 'TestJob' }
    let(:args) { ['foo', 'bar'] }
    let(:executor) do
      Barbeque::Executor.new(job: job, message: JSON.dump(args))
    end

    it 'calls #perform of given job' do
      expect(TestJob).to receive(:perform_now).with(*args)
      executor.run
    end
  end
end
