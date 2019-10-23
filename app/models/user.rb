class User < ApplicationRecord
	validates :email, uniqueness: true, presence: true

	validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 

	has_many :group_events, foreign_key: :creator_id
end
