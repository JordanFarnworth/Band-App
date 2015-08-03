require 'rails_helper'

RSpec.describe EntitiesController, type: :controller do
  let!(:user) { create :user }
  let!(:entity) { create :band }
  let!(:entity_user) { create :entity_user, user: user, entity: entity }

  before :each do
    logged_in_user user
  end

  it 'switches to a given entity' do
    post :switch, id: entity.id
    expect(response).to redirect_to root_path
    expect(session[:current_entity_id]).to eql entity.id
    expect(controller.current_entity).to eql entity
  end

  it 'does not switch to an entity if the user has no affiliation' do
    entity_user.destroy
    post :switch, id: entity.id
    expect(response).to redirect_to root_path
    expect(session[:current_entity_id]).to be_nil
  end

  it 'does not switch if the user is not logged in' do
    log_out
    post :switch, id: entity.id
    expect(session[:current_entity_id]).to be_nil
  end

  it 'cancels viewing as an entity' do
    session[:current_entity_id] = entity.id
    delete :cancel_view
    expect(session[:current_entity_id]).to be_nil
  end
end
