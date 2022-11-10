# frozen_string_literal: true
require 'rails_helper'

shared_examples_for 'API Update object' do
  context 'authorized' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    context 'with valid attributes' do
      before do
        do_request(method, api_path, params: params.merge(access_token: access_token.token))
      end

      it 'changes object attributes' do
        object.reload

        expect(object.body).to eq 'new body'
      end
    end

    context 'with invalid attributes' do
      before do
        do_request(method, api_path, params: "foo")
      end

      it 'returns error code 401' do
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
