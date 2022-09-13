# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author_id: user.id) }
  let!(:answer) { create(:answer, author_id: user.id, question: question) }

  describe 'GET #new' do
    before { login(user) }    
    before { get :new, params: { question_id: question } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new answer to db' do
        expect do
          post :create, params: { answer: attributes_for(:answer).merge(author_id: user.id), question_id: question }
        end.to change(Answer, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer).merge(author_id: user.id), question_id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'doesnt save the answer' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, :invalid).merge(author_id: user.id), question_id: question }
        end.to_not change(Answer, :count)
      end

      it 're-rendres show view' do
        post :create, params: { answer: attributes_for(:answer, :invalid).merge(author_id: user.id), question_id: question }
        expect(response).to render_template :show
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:another_user) { create(:user) }
    let!(:another_answer) { create(:answer, author_id: another_user.id, question: question) }
    let!(:answer) { create(:answer, author_id: user.id, question: question) }

    before { login(user) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'deletes someone else answer' do
      expect { delete :destroy, params: { id: another_answer } }.to change(Question, :count).by(0)
    end

  end
end
