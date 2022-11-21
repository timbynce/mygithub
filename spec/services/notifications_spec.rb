require 'rails_helper'

RSpec.describe NotificationsService do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  it 'sends notification' do
    NotificationsService.new(answer).send_notification
  end
end
