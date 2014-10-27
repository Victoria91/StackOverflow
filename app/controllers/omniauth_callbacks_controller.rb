class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :find_user_for_oauth

  def facebook
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end

  def vkontakte
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    end
  end

  private
  def find_user_for_oauth
    @user = User.find_for_oauth(request.env['omniauth.auth'])
  end
end
