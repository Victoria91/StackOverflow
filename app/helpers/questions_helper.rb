module QuestionsHelper
  def user_info(user)
    image_tag(user.authorizations.first.avatar_url) if user.try(:authorizations).present?
  end
end
