class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :find_user_for_oauth, except: :create_user

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

  def twitter
    if @user
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      @user = User.new
      session[:uid] = request.env['omniauth.auth'].uid 
      session[:provider] = request.env['omniauth.auth'].provider 
      render 'authorizations/new'
    end
  end

  private
  def find_user_for_oauth
    @user = User.find_for_oauth(request.env['omniauth.auth'])
  end
end
