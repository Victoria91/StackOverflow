module QuestionsHelper
  def user_info(user)
    image = user.try(:authorizations).present? ? user.authorizations.first.avatar_url : 'user.png'
    image_tag(image)
  end
end
