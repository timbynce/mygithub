require 'rails_helper'

RSpec.describe NotificationsJob, type: :job do
	let(:service) { double('Service::Notifications')}
	let(:user) { create(:user) }
  let(:question) { create(:question, author_id: user.id) }
  let(:answer) { create(:answer, question: question, author: user) }

  before do
    allow(NotificationsService).to receive(:new).and_return(service)
  end

  it 'calls Service::Notifications#send_notification' do
    expect(service).to receive(:send_notification)
    NotificationsJob.perform_now(answer)
  end
end
