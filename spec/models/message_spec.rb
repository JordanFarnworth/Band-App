require 'rails_helper'

RSpec.describe Message, type: :model do
  let!(:sender) { create :entity }
  let!(:message_thread) { create :message_thread }
  let!(:entity1) { create :band }
  let!(:participant1) { create :message_participant, message_thread: message_thread, entity: entity1 }
  let!(:participant2) { create :message_participant, message_thread: message_thread, entity: sender }
  let!(:message) { create :message, sender: sender, message_thread: message_thread }

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
    let!(:future_message) { create :message, sender: sender, message_thread: message_thread, created_at: 1.day.from_now }

    it 'uses a chronological scope' do
      expect(Message.chronological.to_a).to eql [message, future_message]
    end

    it 'uses a reverse chronological scope' do
      expect(Message.reverse_chronological.to_a).to eql [future_message, message]
    end

    it 'returns messages between 2 entities' do
      expect(Message.between_entities(entity1, sender).to_a).to eql [future_message, message]
    end
  end
end
