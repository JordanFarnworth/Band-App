require 'rails_helper'

RSpec.describe Entity, type: :model do
  let(:entity) { create :band }

  describe 'validations' do
    it { expect(entity.update(name: nil)).to be_falsey }
    it { expect(entity.update(description: nil)).to be_falsey }
  end

  describe 'associations' do
    it { expect(entity).to respond_to :user }
    it { expect(entity).to respond_to :messages }
    it { expect(entity).to respond_to :message_participants }
    it { expect(entity).to respond_to :unread_messages }
  end
end
