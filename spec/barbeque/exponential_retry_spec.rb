describe BarbequeClient::ExponentialRetry do
  describe '#retry' do
    let(:fixed_rand_30) { rand(30) }
    let(:count) { 5 }
    let(:client) { double('BarbequeClient::Client') }
    let(:message_id) { SecureRandom.uuid }

    before do
      allow(BarbequeClient).to receive(:client).and_return(client)
      allow(BarbequeClient::ExponentialRetry).to receive(:rand).with(30).and_return(fixed_rand_30)
    end

    it 'calls retry_execution with exponential backoff' do
      expect(client).to receive(:retry_execution).with(
        message_id:    message_id,
        delay_seconds: BarbequeClient::ExponentialRetry.exponential_backoff(count),
      )
      BarbequeClient::ExponentialRetry.new(count).retry(message_id)
    end
  end
end
