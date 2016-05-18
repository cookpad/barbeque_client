describe Barbeque::Client do
  let(:client) { described_class.new(application: application, default_queue: default_queue, endpoint: endpoint) }
  let(:application) { 'cookpad' }
  let(:default_queue) { 'main' }
  let(:endpoint) { 'https://barbeque.example.com' }
  let(:garage_client) { double('GarageClient::Client') }
  let(:result) { double('GarageClient::Response', response: double('Faraday::Response')) }

  before do
    allow(GarageClient::Client).to receive(:new).and_return(garage_client)
  end

  describe '#create_execution' do
    let(:message) { { user_id: 1 } }

    context 'when barbeque is alive' do
      let(:job) { 'NotifyAuthor' }

      it 'enqueues a job to barbeque' do
        expect(garage_client).to receive(:post).with(
          '/v1/job_executions',
          application: application,
          job:         job,
          message:     message.to_json,
          queue:       default_queue,
        ).and_return(result)
        client.create_execution(job: job, message: message)
      end

      context 'given custom queue' do
        let(:queue) { 'bargain' }

        it 'enqueues with specified parameters' do
          expect(garage_client).to receive(:post).with(
            '/v1/job_executions',
            application: application,
            job:         job,
            message:     message.to_json,
            queue:       queue,
          ).and_return(result)
          client.create_execution(job: job, message: message, queue: queue)
        end
      end
    end

    context 'when barbeque responds with error' do
      before do
        allow(garage_client).to receive(:post).and_raise(
          GarageClient::BadRequest.new(
            '{"status_code":400,"error_code":"invalid_parameter","message":"params[:job] must be a valid String"}'
          )
        )
      end

      it 'raises GarageClient::Error' do
        expect {
          client.create_execution(job: nil, message: message)
        }.to raise_error(GarageClient::Error)
      end
    end
  end

  describe '#retry_execution' do
    let(:message_id) { SecureRandom.uuid }
    let(:result) { double('GarageClient::Response', response: double('Faraday::Response')) }

    it 'retries a specified message' do
      expect(garage_client).to receive(:post).with(
        "/v1/job_executions/#{message_id}/retries",
        delay_seconds: 0,
      ).and_return(result)
      client.retry_execution(message_id: message_id)
    end

    context 'given delay_seconds' do
      let(:delay_seconds) { 900 }

      it 'retries a specified message with delay' do
        expect(garage_client).to receive(:post).with(
          "/v1/job_executions/#{message_id}/retries",
          delay_seconds: delay_seconds,
        ).and_return(result)
        client.retry_execution(message_id: message_id, delay_seconds: delay_seconds)
      end
    end

    context 'given invalid delay_seconds' do
      let(:delay_seconds) { 901 }

      before do
        allow(garage_client).to receive(:post).and_raise(
          GarageClient::BadRequest.new('{"status":400,"error":"invalid_parameter"}')
        )
      end

      it 'raises GarageClient::Error' do
        expect {
          client.retry_execution(message_id: message_id, delay_seconds: delay_seconds)
        }.to raise_error(GarageClient::Error)
      end
    end
  end

  describe '#execution' do
    let(:message_id) { SecureRandom.uuid }
    let(:result) { double('GarageClient::Response', response: response) }
    let(:response) { double('Faraday::Response', body: { message_id: message_id, status: 'success' }) }

    before do
      allow(garage_client).to receive(:get).with("/v1/job_executions/#{message_id}").and_return(result)
    end

    it 'returns an execution' do
      expect(client.execution(message_id: message_id)).to eq(response)
    end

    context 'when barbeque responds with error' do
      before do
        allow(garage_client).to receive(:get).and_raise(
          GarageClient::BadRequest.new('{"status":404,"error":"Not Found"}')
        )
      end

      it 'raises GarageClient::Error' do
        expect {
          client.execution(message_id: message_id)
        }.to raise_error(GarageClient::Error)
      end
    end
  end
end
