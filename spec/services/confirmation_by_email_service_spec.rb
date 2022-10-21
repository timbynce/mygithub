# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConfirmationByEmailService, type: :model do
  describe 'call' do
    let!(:authorization) { create(:authorization) }
    let!(:params) { { token: '1234' } }

    it 'can confirm' do
      expect(ConfirmationByEmailService.call(params)).to eq(authorization.user)
    end
  end
end
