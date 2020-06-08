class User < ApplicationRecord
	validates :name,:email,:password, presence: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	attr_accessor :remember_token
	#validates :name,length: {minimum: 2,maximum:150}
	validates :email,length: {maximum:250, message: "max is 250 characters"}
	validates :email,format: {with: VALID_EMAIL_REGEX}
	validate :check_length_name, if: ->{name.present?}
	has_secure_password
	def check_length_name
		if name.size >150
			errors.add :name,"Length maximum is 150 characters"
		end
		if name.size < 2
			errors.add :name,"Length minimum is 2 characters"
		end
	end
	def remember
		self.remember_token= SecureRandom.urlsafe_base64
        update_attribute :remember_digest ,User.digest(remember_token)
	end
	def forget
		update_attribute :remember_digest,nil
	end
	def authenticate? token
		BCrypt::Password.new(remember_digest).is_password?(token)
	end
	class << self
	def digest token
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(token, cost: cost)
	end
	end
end
