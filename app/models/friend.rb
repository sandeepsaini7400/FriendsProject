class Friend < ApplicationRecord
  paginates_per 10
	belongs_to :user
	has_one_attached :profile_image  

	resourcify
	# has_many :users, -> { distinct }, through: :roles, class_name: 'User', source: :users
	# has_many :creators, -> { where(:roles {name: :creator}) }, through: :roles, class_name: 'User', source: :users

	validates :first_name, :last_name, length: {minimum:2, maximum:50} 
	validates :first_name, :last_name, format: {with: /\A[a-zA-Z]+\z/, message:"only latters are allowed"}
	validates :first_name, :last_name, :email, :phone, :instagram, :twitter, presence: true
	validates :email,presence: { message: "must be given please" }, uniqueness: true
end
