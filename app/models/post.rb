class Post < ApplicationRecord
  belongs_to :friend
  has_one_attached :profile_image  


  validate :profile_image, :presence


  def image_presence
    errors.add(:profile_image,"can't be blank") unless profile_image.attached?
  end
end
