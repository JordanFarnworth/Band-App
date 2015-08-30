require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let!(:sender) { create :entity }
  let!(:recipient) { create :entity }
  let!(:message_thread) { create :message_thread }
  let!(:sender_participant) { create :message_participant, entity: sender, message_thread: message_thread }
  let!(:recipient_participant) { create :message_participant, entity: recipient, message_thread: message_thread }

  describe '#index' do
    it 'returns messages in a thread' do
      message = create :message, message_thread: message_thread
      get :index, format: :json, message_thread_id: message_thread.id
      json = JSON.parse response.body
      expect(json['results'].map { |m| m['id'] }).to eql [message.id]
    end
  end

  describe '#create' do
    it 'creates a message' do
      post :create, entity_id: sender.id, message: { body: 'testest', subject: 'testest', recipient_id: recipient.id }
      message = message_thread.messages.first
      expect(message).to_not be_nil
      expect(message.sender).to eql sender
    end

    it 'creates a message thread' do
      sender_participant.really_destroy!
      recipient_participant.really_destroy!
      message_thread.destroy
      post :create, entity_id: sender.id, message: { body: 'testest', subject: 'testest', recipient_id: recipient.id }
      expect(MessageThread.between_entities(sender, recipient)).to_not be_nil
    end
  end
end
