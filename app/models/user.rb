class User < ApplicationRecord
  paginates_per 5

  rolify
  has_many :friends 
  has_one_attached :image
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :assign_default_role


  validate :must_have_a_role, on: :update


  def self.ransackable_attributes(auth_object = nil)
    ["email"]
  end


  def must_have_a_role
    unless roles_name
      errors.add(:roles, "must have at least one role")
    end
  end
  
  private
  def assign_default_role
    self.add_role(:newuser) if self.roles.blank?
  end
end


