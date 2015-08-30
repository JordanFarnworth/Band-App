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
    it { expect(user).to respond_to :entity }
    it { expect(user).to respond_to :band }
    it { expect(user).to respond_to :party }
  end
end
