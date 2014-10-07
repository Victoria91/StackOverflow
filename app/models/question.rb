class Question < ActiveRecord::Base
	has_many :answers
	belongs_to :user
	has_many :attachments, as: :attachmentable

	validates :title, :body, presence: true
	validates :title, length: { maximum: 255 }


  def accepted_answer 
    self.answers.find_by(accepted: true)
  end

  def toggle_accepted(answer) 
    accepted_answer.update!(accepted: false) if accepted_answer and !answer.accepted?
		answer.toggle(:accepted).save!
	end

end
