require 'bcrypt'

class User

	attr_reader :password
	attr_accessor :password_confirmation

	include DataMapper::Resource

	property :id, Serial
	property :email, String, unique: true
	property :password_digest, Text
	property :token, String, length: 64

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	validates_uniqueness_of :email
	validates_confirmation_of :password

	def self.authenticate(email, password)
		user = first(email: email)
		if user && BCrypt::Password.new(user.password_digest) == password
			user
		else
			nil
		end
	end

	def self.recover_password(email)
		user = first(email: email)
		if user
			user.token = SecureRandom.hex(32)
			user.save
		else
			nil
		end
	end

end