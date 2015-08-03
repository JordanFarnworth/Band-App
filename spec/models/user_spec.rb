require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create :user }

  describe 'validations' do
    let(:new_user) { build :user }

    it { expect(new_user.update(username: user.username)).to be_falsey }
    it { expect(new_user.update(display_name: nil)).to be_falsey }
    it { expect(new_user.update(email: user.email)).to be_falsey }
    it { expect(new_user.update(state: 'asdf')).to be_falsey }
    it { expect(user.registration_token).to_not be_nil }
  end

  describe 'associations' do
    it { expect(user).to respond_to :entities }
    it { expect(user).to respond_to :entity_users }
    it { expect(user).to respond_to :bands }
    it { expect(user).to respond_to :parties }

    describe 'entities' do
      let!(:band) { create :band }
      let!(:band_user) { band.add_user(user) }
      let!(:party) { create :party }
      let!(:party_user) { party.add_user(user) }

      it 'determines proper inheritance of entities in assocations' do
        expect(user.entities.pluck(:id)).to include(band.id, party.id)
        expect(user.bands.pluck(:id)).to eql [band.id]
        expect(user.parties.pluck(:id)).to eql [party.id]
      end
    end
  end
end
