# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author_id: user.id) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :post }
    let(:params) do
      { question: question,
        answer: attributes_for(:answer).merge(author_id: user.id) }
    end

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API Create object', Question
  end

  describe 'PATCH /api/v1/answers/id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author_id: user.id) }
    let!(:object) { create(:answer, question: question, author_id: user.id) }
    let(:api_path) { "/api/v1/answers/#{object.id}" }
    let(:method) { :patch }
    let(:params) do
      { id: object, question: question, answer: { body: 'new body' } }
    end

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API Update object'
  end

  describe 'DELETE /api/v1/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author_id: user.id) }
    let!(:object) { create(:answer, question: question, author_id: user.id) }
    let(:api_path) { "/api/v1/answers/#{object.id}" }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API Delete object' do
      let(:described_class) { Answer }
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author_id: user.id) }
    let(:answer) { create(:answer, :with_attachments, question: question, author_id: user.id) }
    let!(:links) { create_list(:link, 3, linkable: answer) }
    let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :get }
    let(:object_response) { json['answer'] }
    let(:public_fields) { %w[body created_at updated_at] }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it_behaves_like 'API GET links, comments and attached files'
    end

    context 'unauthorized' do
      it 'not returns successful status' do
        get api_path, params: { format: :json }, headers: headers
        expect(response.status).to eq 401
      end
    end
  end
end
