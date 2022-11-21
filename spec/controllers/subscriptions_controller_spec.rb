require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, author_id: user.id) }

  describe 'POST #create' do
    let(:create_request) { post :create, params: { question_id: question, format: :js } }

    context 'authenticated user' do
      before { login(user) }

      it 'saves question subscription in database' do
        expect { create_request }.to change(question.subscriptions, :count).by(1)
      end

      it 'assigns subscription to current_user' do
        create_request
        expect(assigns(:subscription).user).to eq user
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, question: question, user_id: user.id) }
    let(:destroy_request) { delete :destroy, params: { id: subscription, format: :js } }

    context 'authenticated user' do
      before { login(user) }

      it 'deletes subscription' do
        expect { destroy_request }.to change(Subscription, :count).by(-1)
      end
    end

    context 'unauthenticated user' do
      it 'tries to deletes subscription' do
        expect { destroy_request }.to change(Subscription, :count).by(0)
      end
    end
  end
end
