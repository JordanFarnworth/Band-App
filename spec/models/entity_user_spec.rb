require 'rails_helper'

RSpec.describe EntityUser, type: :model do
  let!(:entity_user) { create :entity_user }
  let(:user) { entity_user.user }
  let(:entity) { entity_user.entity }

  describe 'validations' do
    it 'is unique per user and entity' do
      eu2 = build :entity_user, user: user, entity: entity
      expect(eu2.save).to be_falsey
    end

    it { expect(entity_user.update(role: 'asdf')).to be_falsey }
    it { expect(entity_user.role).to eql 'member' }
  end

  describe 'associations' do
    it { expect(entity_user).to respond_to :user }
    it { expect(entity_user).to respond_to :entity }
  end
end
