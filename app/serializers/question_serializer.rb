class QuestionSerializer < ActiveModel::Serializer
  attributes :user, :id, :title, :body, :created_at, :updated_at, :avatar_url

  has_many :answers, :attachments

  def avatar_url
    object.user.authorizations.first.avatar_url if object.user.authorizations.present?
  end
end
