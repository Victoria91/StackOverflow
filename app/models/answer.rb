class Answer < ActiveRecord::Base
	belongs_to :question
	belongs_to :user
	has_many :attachments, as: :attachmentable

	accepts_nested_attributes_for :attachments 

	validates :body, :question, presence: true

  def toggle_accepted
    @accepted_answer ||= question.accepted_answer
    @accepted_answer.update!(accepted: false) if @accepted_answer && ! accepted
    toggle(:accepted).save!
  end
end
