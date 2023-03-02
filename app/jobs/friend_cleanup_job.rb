class FriendCleanupJob < ApplicationJob
  queue_as :default

  def perform(friend)
    CrudNotificationMailer.create_notification(friend).deliver_now
  end
end
