require 'rails_helper'

RSpec.describe MessageParticipant, type: :model do
  let(:message_participant) { create :message_participant }

  describe 'validations' do
    it { expect(message_participant.update(message_thread: nil)).to be_falsey }
    it { expect(message_participant.update(entity: nil)).to be_falsey }
    it { expect(message_participant.update(state: 'asdf')).to be_falsey }
    it { expect(message_participant.state).to eql 'unread' }
  end

  describe 'associations' do
    it { expect(message_participant).to respond_to :entity }
    it { expect(message_participant).to respond_to :message_thread }
  end

  describe 'scoping' do
    it 'has an unread scope' do
      expect(MessageParticipant.unread).to include message_participant
      message_participant.update state: :read
      expect(MessageParticipant.unread).to_not include message_participant
    end
  end

end
