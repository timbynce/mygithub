# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'API Delete object' do
  context 'authorized' do
    context 'with valid attributes' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      before do
        delete api_path, params: { id: object, access_token: access_token.token }
      end

      it 'deletes the object' do
        expect(described_class.count).to eq 0
      end

      it 'returns successful message' do
        expect(json['messages']).to include("#{described_class} deleted")
      end
    end

    context 'with invalid attributes' do
      before do
        delete api_path, params: 'foo'
      end

      it 'returns error code 401' do
        expect(response.status).to eq 401
      end
    end
  end

  context 'unauthorized' do
    it 'not returns successful status' do
      delete api_path, params: { id: object }

      expect(response.status).to eq 401
    end
  end
end
