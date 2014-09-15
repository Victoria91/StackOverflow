class Question < ActiveRecord::Base
	validates :title, :body, presence: true
	validates :title, length: { maximum: 255 }
	has_many :answers
end
