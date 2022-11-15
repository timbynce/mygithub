# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:questions) { create_list(:question, 2, author_id: user.id) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, author_id: user.id, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contatins user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end

        it 'contatins user object' do
          expect(question_response['author']['id']).to eq question.author.id
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_attachments, author_id: user.id) }
    let!(:answers) { create_list(:answer, 3, author_id: user.id, question: question) }
    let!(:links) { create_list(:link, 3, linkable: question) }
    let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
    let(:object_response) { json['question'] }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }
    let(:access_token) { create(:access_token) }
    let(:public_fields) { %w[title body created_at updated_at] }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it_behaves_like 'API GET links, comments and attached files' do
        let(:entity) { question }
      end

      context 'answers' do
        before do
          get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }
        end

        it 'have list of answers' do
          expect(object_response['answers'].size).to eq(answers.size)
        end
      end
    end

    context 'unauthorized' do
      it 'not returns successful status' do
        get api_path, params: { format: :json }, headers: headers
        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :post }
    let(:params) do
      { question: attributes_for(:question).merge(author_id: user.id) }
    end

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API Create object', Question
  end

  describe 'PATCH /api/v1/questions' do
    let(:user) { create(:user) }
    let!(:object) { create(:question, author_id: user.id) }
    let(:api_path) { "/api/v1/questions/#{object.id}" }
    let(:method) { :patch }
    let(:params) do
      { id: object, question: { body: 'new body' } }
    end

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API Update object'
  end

  describe 'DELETE /api/v1/questions' do
    let(:user) { create(:user) }
    let!(:object) { create(:question, author_id: user.id) }
    let(:api_path) { "/api/v1/questions/#{object.id}" }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API Delete object' do
      let(:described_class) { Question }
    end
  end
end
