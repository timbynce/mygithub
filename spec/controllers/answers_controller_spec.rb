# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, author: user) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 3, question: question, author_id: user.id) }

    before { get :index, params: { question_id: question, author_id: user.id } }

    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
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
        expect(response).to redirect_to assigns(:question)
      end
    end
  end
end
