class Friend < ApplicationRecord
	belongs_to :user
	has_one_attached :profile_image  

	

	validates :first_name, :last_name, length: {minimum:2, maximum:50} 
	validates :first_name, :last_name, format: {with: /\A[a-zA-Z]+\z/, message:"only latters are allowed"}
	validates :first_name, :last_name, :email, :phone, :instagram, :twitter, presence: true
	validates :email,presence: { message: "must be given please" }, uniqueness: true
end
