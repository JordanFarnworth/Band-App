require 'rails_helper'

RSpec.describe LoginController, :type => :controller do
  describe 'GET index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'POST index' do
    let(:user) { create :user, password: 'abcd' }

    describe 'successful login' do
      let :params do
        {user: { username: user.username, password: 'abcd' }, format: :js }
      end

      it 'should assign a new login session as a cookie' do
        post :verify, params
        expect(session[:current_user_id]).to eql user.id
      end
    end

    describe 'unsuccessful login' do
      let(:params) do
        {user: { username: user.username, password: '1234' }, format: :js }
      end

      it 'should render an unauthorized error for ajax' do
        post :verify, params
        expect(response.status).to eql 401
      end
    end
  end

  describe 'DELETE index' do
    let(:user) { create :user, password: 'abcd' }

    let(:params) do
      {user: { username: user.username, password: 'abcd' }, format: :js }
    end

    it 'should expire the login session' do
      post(:verify, params)
      delete :logout
      expect(session).to_not include :current_user_id
    end

    it 'should delete the session cookie' do
      post(:verify, params)
      delete :logout
      expect(response.cookies['tickets_key']).to be_nil
    end

    it 'should redirect to root' do
      post(:verify, params)
      delete :logout
      expect(response).to redirect_to(:root)
    end
  end


    it 'confirms a user\'s registration' do
      user = create :user, state: :pending_approval
      get :confirm_registration, token: user.registration_token
      expect(response).to redirect_to :root
      expect(user.reload.state).to eql 'active'
    end
  end
