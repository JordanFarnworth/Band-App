require 'rails_helper'

RSpec.describe Entity, type: :model do
  let(:entity) { create :band }

  describe 'validations' do
    it { expect(entity.update(name: nil)).to be_falsey }
    it { expect(entity.update(description: nil)).to be_falsey }
  end

  describe 'associations' do
    it { expect(entity).to respond_to :entity_users }
    it { expect(entity).to respond_to :users }
    it { expect(entity).to respond_to :messages }
    it { expect(entity).to respond_to :message_participants }
    it { expect(entity).to respond_to :unread_messages }
  end

  describe 'adding users' do
    let(:user) { create :user }

    it 'gives a default role of member' do
      entity_user = entity.add_user user
      expect(entity_user.role).to eql 'member'
    end

    it 'updates an existing record if one is present' do
      entity_user = entity.add_user user
      entity_user2 = entity.add_user user
      expect(entity_user.id).to eql entity_user2.id
    end
  end
end
