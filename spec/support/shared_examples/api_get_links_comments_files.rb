# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'API GET links, comments and attached files' do
  before { get api_path, params: { format: :json, access_token: access_token.token }, headers: headers }

  it 'returns 200 status code' do
    expect(response).to be_successful
  end

  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(object_response[attr]).to eq entity.send(attr).as_json
    end
  end

  context 'comments' do
    it 'have list of comments' do
      expect(object_response['comments']).to eq(comments.pluck(:body))
    end
  end

  context 'Links' do
    it 'have list of links' do
      expect(object_response['links']).to eq(links.pluck(:url))
    end
  end

  context 'Files' do
    it 'have list of files' do
      expect(object_response['files'].size).to eq(entity.files.size)
    end
  end
end
