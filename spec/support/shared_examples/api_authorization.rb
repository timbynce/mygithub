# frozen_string_literal: true

require 'rails_helper'
shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status' do
      do_request(method, api_path, headers: headers)

      expect(response.status).to eq 401
    end
  end
end
