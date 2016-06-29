describe TestJob do
  let(:application) { 'test' }
  let(:endpoint)    { 'https://dummy.com' }
  let(:config) do
    Barbeque::Configuration.new.tap do |c|
      c.application = application
      c.endpoint    = endpoint
    end
  end
  let(:response) { double('Faraday::Response', body: Hashie::Mash.new(message_id: message_id)) }
  let(:client) { double('Barbeque::Client') }
  let(:args) { ['hello world'] }
  let(:message_id) { SecureRandom.uuid }

  before do
    allow(Barbeque).to receive(:client).and_return(client)
    allow(Barbeque).to receive(:config).and_return(config)
    allow(client).to receive(:create_execution).and_return(response)
  end

  describe '.perform_later' do
    it 'enqueues a job to barbeque' do
      expect(client).to receive(:create_execution).with(
        job:     'TestJob',
        message: args,
        queue:   'test_queue',
      ).and_return(response)
      TestJob.perform_later(*args)
    end

    it 'sets message_id of barbeque execution' do
      job = TestJob.perform_later(*args)
      expect(job.job_id).to eq(message_id)
    end

    context 'with timestamp set' do
      it 'is not supported' do
        expect {
          TestJob.set(wait: 1.week).perform_later
        }.to raise_error(NotImplementedError)
      end
    end
  end

  describe '.perform_now' do
    let(:retry_count) { 0 }
    let(:test_job) { TestJob.new.tap { |job| job.job_id = message_id } }
    let(:exponential_retry) { Barbeque::ExponentialRetry.new(retry_count) }
    let(:message_id) { SecureRandom.uuid }

    before do
      allow(TestJob).to receive(:new).and_return(test_job)
      allow(test_job).to receive(:perform).and_raise(error)
      allow(Barbeque::ExponentialRetry).to receive(:new).with(retry_count).and_return(exponential_retry)
      ENV['BARBEQUE_RETRY_COUNT'] = retry_count.to_s
    end

    context 'when retryable error raised' do
      let(:error) { Timeout::Error }

      it 'retries with barbeque' do
        expect(exponential_retry).to receive(:retry).with(message_id)
        TestJob.perform_now
      end

      context 'when already retried limit count times' do
        let(:retry_count) { 1 }

        it 'raises error' do
          expect { TestJob.perform_now }.to raise_error(error)
        end
      end
    end

    context 'when not-retryable error raised' do
      let(:error) { NotImplementedError }

      it 'raises error' do
        expect { TestJob.perform_now }.to raise_error(error)
      end
    end
  end
end
