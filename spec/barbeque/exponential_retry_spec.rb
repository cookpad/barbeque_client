describe Barbeque::ExponentialRetry do
  describe '#retry' do
    let(:fixed_rand_30) { rand(30) }
    let(:count) { 5 }
    let(:client) { double('Barbeque::Client') }
    let(:message_id) { SecureRandom.uuid }

    before do
      allow(Barbeque).to receive(:client).and_return(client)
      allow(Barbeque::ExponentialRetry).to receive(:rand).with(30).and_return(fixed_rand_30)
    end

    it 'calls retry_execution with exponential backoff' do
      expect(client).to receive(:retry_execution).with(
        message_id:    message_id,
        delay_seconds: Barbeque::ExponentialRetry.exponential_backoff(count),
      )
      Barbeque::ExponentialRetry.new(count).retry(message_id)
    end
  end
end
