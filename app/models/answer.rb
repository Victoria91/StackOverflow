class Answer < ActiveRecord::Base
	belongs_to :question
	belongs_to :user
	has_many :attachments, as: :attachmentable

	accepts_nested_attributes_for :attachments 

	validates :body, :question, presence: true
end
