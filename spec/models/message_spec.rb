require 'rails_helper'

RSpec.describe Message, type: :model do
  let!(:sender) { create :entity }
  let!(:message) { create :message, sender: sender }

  describe 'validations' do
    it { expect(message.update(subject: 'a')).to be_falsey }
    it { expect(message.update(body: 'a')).to be_falsey }
    it { expect(message.update(sender: nil)).to be_falsey }
  end

  describe 'associations' do
    it { expect(message).to respond_to :message_participants }
    it { expect(message).to respond_to :entities }
    it { expect(message.sender).to eql sender }
  end

  describe 'scoping' do
    let!(:future_message) { create :message, sender: sender, created_at: 1.day.from_now }

    it 'uses a chronological scope' do
      expect(Message.chronological.to_a).to eql [message, future_message]
    end

    it 'uses a reverse chronological scope' do
      expect(Message.reverse_chronological.to_a).to eql [future_message, message]
    end
  end
end
