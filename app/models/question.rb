class Question < ActiveRecord::Base
	has_many :answers
	belongs_to :user

	validates :title, :body, presence: true
	validates :title, length: { maximum: 255 }
end
