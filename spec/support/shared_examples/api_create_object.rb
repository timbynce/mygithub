# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'API Create object' do |entity|
  context 'authorized' do
    let!(:access_token) { create(:access_token) }

    context 'valid params' do
      it 'saves a new object in database' do
        expect do
          do_request(method, api_path, params: params.merge(access_token: access_token.token))
        end.to change(entity, :count).by(1)
      end

      it 'returns successful status' do
        do_request(method, api_path, params: params.merge(access_token: access_token.token))
        expect(response).to be_successful
      end
    end

    context 'invalid params' do
      it 'returns successful status' do
        do_request(method, api_path, params: 'foo')

        expect(response.status).to eq 401
      end
    end
  end

  context 'unauthorized' do
    it 'not returns successful status' do
      do_request(method, api_path, params: params)

      expect(response.status).to eq 401
    end
  end
end
