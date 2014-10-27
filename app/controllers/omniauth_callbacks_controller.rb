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
      @uid = request.env['omniauth.auth'].uid 
      @provider = request.env['omniauth.auth'].provider 
      render 'devise/confirmations/new'
    end
  end

  def create_user
    #render json: request.params   
    @user = User.create(user_params.merge(password:'qwerty12123213', password_confirmation:'qwerty12123213'))
    @user.send_confirmation_instructions
    redirect_to root_path, notice: 'confirmation sent'
  end

  private
  def user_params 
    params[:user].permit(:email, authorizations_attributes: [:provider, :uid,])
  end

  private
  def find_user_for_oauth
    @user = User.find_for_oauth(request.env['omniauth.auth'])
  end
end
