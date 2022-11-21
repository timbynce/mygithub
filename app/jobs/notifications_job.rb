class NotificationsJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NotificationsService.new(answer).send_notification
  end
end
