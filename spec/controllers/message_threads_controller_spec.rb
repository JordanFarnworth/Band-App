require 'rails_helper'

RSpec.describe MessageThreadsController, type: :controller do
  let!(:user) { create :user }
  let!(:sender) { create :band }
  let!(:entity1) { create :band, user: user }
  let!(:message_thread) { create :message_thread }
  let!(:participant1) { create :message_participant, message_thread: message_thread, entity: sender }
  let!(:participant2) { create :message_participant, message_thread: message_thread, entity: entity1 }
  let!(:message) { create :message, message_thread: message_thread }

  before :each do
    logged_in_user user
  end

  describe '#index' do
    it 'returns message threads' do
      get :index, entity_id: sender.id, include: ['latest_message', 'entities']
      json = JSON.parse(response.body)
      expect(json['results'].map { |r| r['id'] }).to eql [message_thread.id]
      expect(json['results'].first['entities'].map { |e| e['id'] }).to eql [sender.id, entity1.id]
      expect(json['results'].first['latest_message']['id']).to eql message.id
    end
  end

  describe '#show' do
    it 'returns a message thread' do
      get :show, id: message_thread.id, include: ['latest_message', 'entities']
      json = JSON.parse(response.body)
      expect(json['id']).to eql message_thread.id
      expect(json['entities'].map { |e| e['id'] }).to eql [sender.id, entity1.id]
      expect(json['latest_message']['id']).to eql message.id
    end
  end
end
