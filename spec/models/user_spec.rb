require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  describe 'validations' do
    let(:new_user) { build :user }

    it { expect(new_user.update(username: user.username)).to be_falsey }
    it { expect(new_user.update(display_name: nil)).to be_falsey }
    it { expect(new_user.update(email: user.email)).to be_falsey }
    it { expect(new_user.update(state: 'asdf')).to be_falsey }
  end
end
