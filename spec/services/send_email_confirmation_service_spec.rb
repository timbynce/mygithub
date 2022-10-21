# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendEmailConfirmationService, type: :model do
  describe 'call' do
    let!(:params) { { provider: 'VK', uid: '123456', email: '123@mail.com' } }

    it 'can send email to address' do
      expect(SendEmailConfirmationService.call(params)).to eq('success')
    end
  end
end
