# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author_id: user.id) }
  let!(:answer) { create(:answer, author_id: user.id, question: question) }

  it 'includes MyControllerConcern' do
    expect(AnswersController.ancestors.include? Voted).to be(true) 
  end

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
          post :create, params: { answer: attributes_for(:answer).merge(author_id: user.id), question_id: question },
                        format: :js
        end.to change(Answer, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer).merge(author_id: user.id), question_id: question },
                      format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'doesnt save the answer' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, :invalid).merge(author_id: user.id), question_id: question },
               format: :js
        end.to_not change(Answer, :count)
      end

      it 're-rendres create view' do
        post :create,
             params: { answer: attributes_for(:answer, :invalid).merge(author_id: user.id), question_id: question },
             format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:another_user) { create(:user) }
    let!(:another_answer) { create(:answer, author_id: another_user.id, question: question) }
    let!(:answer) { create(:answer, author_id: user.id, question: question) }

    before { login(user) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'deletes someone else answer' do
      expect { delete :destroy, params: { id: another_answer }, format: :js }.to change(Question, :count).by(0)
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, author_id: user.id, question: question) }

    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer body' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    describe 'PATCH #updatebest' do
      let!(:answer) { create(:answer, author_id: user.id, question: question) }
      before { login(user) }

      it 'changes best answer' do
        patch :update_best, params: { id: answer }, format: :js
        answer.reload
        expect(question.reload.best_answer_id).to eq answer.id
      end

      it 'renders :update_best template' do
        patch :update_best, params: { id: answer }, format: :js
        expect(request).to render_template :update_best
      end
    end
  end
end
