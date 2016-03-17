describe TestJob do
  let(:application) { 'test' }
  let(:endpoint)    { 'https://dummy.com' }
  let(:config) do
    Barbeque::Configuration.new.tap do |c|
      c.application = application
      c.endpoint    = endpoint
    end
  end
  let(:response) { double('Faraday::Response', body: double('Hashie::Mash', id: id) ) }
  let(:client) { double('Barbeque::Client') }
  let(:args) { ['hello world'] }
  let(:id) { 100 }

  before do
    allow(Barbeque).to receive(:client).and_return(client)
    allow(Barbeque).to receive(:config).and_return(config)
    allow(client).to receive(:create_execution).and_return(response)
  end

  describe '.perform_later' do
    it 'enqueues a job to barbeque' do
      expect(client).to receive(:create_execution).with(
        job:         'TestJob',
        message:     args,
        queue:       'test_queue',
        environment: Rails.env,
      ).and_return(response)
      TestJob.perform_later(*args)
    end

    it 'sets execution id of barbeque' do
      job = TestJob.perform_later(*args)
      expect(job.job_id).to eq(id)
    end

    context 'with timestamp set' do
      it 'is not supported' do
        expect {
          TestJob.set(wait: 1.week).perform_later
        }.to raise_error(NotImplementedError)
      end
    end
  end
end
