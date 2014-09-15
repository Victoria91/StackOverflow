class Answer < ActiveRecord::Base
	validates :body, :question, presence: true
	belongs_to :question
end
