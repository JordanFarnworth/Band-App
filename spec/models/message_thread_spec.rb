require 'rails_helper'

RSpec.describe MessageThread, type: :model do
  let!(:sender) { create :entity }
  let!(:message_thread) { create :message_thread }
  let!(:entity1) { create :band }
  let!(:participant1) { create :message_participant, message_thread: message_thread, entity: entity1 }
  let!(:participant2) { create :message_participant, message_thread: message_thread, entity: sender }

  describe 'associations' do
    it { expect(message_thread).to respond_to :message_participants }
    it { expect(message_thread).to respond_to :entities }
    it { expect(message_thread).to respond_to :messages }
    it { expect(message_thread).to respond_to :sorted_messages }
    it { expect(message_thread).to respond_to :latest_message }
  end

  describe 'scoping' do
    it 'returns a thread between two entities' do
      expect(MessageThread.between_entities(entity1, sender)).to eql message_thread
    end
  end
end
