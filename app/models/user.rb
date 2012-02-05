# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
	attr_accessor :password, :password_confirmation
  	attr_accessible :name, :email, :password, :password_confirmation

	validates :name, presence: true, length: { maximum: 50 }
	valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: valid_email_regex }, 
		uniqueness: { case_sensitive: false }
	validates :password, presence: true
	validates :password_confirmation, presence: true

	rescue ActiveRecord::StatementInvalid
    # Handle duplicate email addresses gracefully by redirecting.
end
