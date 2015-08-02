require 'rails_helper'

RSpec.describe Band, type: :model do
  let(:band) { create :band }

  describe 'validations' do
    Band::REQUIRED_DATA_ATTRIBUTES.each do |attr|
      it "requires a data attribute of #{attr}" do
        band.data[attr] = nil
        expect(band.save).to be_falsey
      end
    end
  end

  it { expect(band.data['genre']).to eql band.genre }
end
