class User < ApplicationRecord
  rolify
  has_many :friends 
  has_one_attached :profile_image  
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :assign_default_role


  validate :must_have_a_role, on: :update

  private
  def assign_default_role
    self.add_role(:newuser) if self.roles.blank?
  end
end

  def must_have_a_role
    unless roles_name
      errors.add(:roles, "must haev at least one role")
    end
  end

