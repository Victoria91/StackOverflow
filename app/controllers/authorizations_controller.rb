class AuthorizationsController < ApplicationController
  def confirm_auth
    @token = Devise.friendly_token[0, 30]
    @user = User.where(user_params).first
    @user ||= User.create(user_params.merge(password: @token, password_confirmation: @token))
    if @user.save
      send_confirmation
    else
      render 'authorizations/new'
    end
  end

  def show
    if params[:token] == session[:token]
      @user = User.where(email: session[:email]).first
      @user.authorizations.create(uid: session[:uid], provider: session[:provider])
      sign_in @user
      flash[:notice] = 'Your email address has been successfully confirmed. Your are now signed in with Twitter account'
    else
      flash[:notice] = 'Invalid confirmation. Try to sign up one more time'
    end
    redirect_to root_path
  end

  private

  def user_params
    params[:user].permit(:email)
  end

  def send_confirmation
    session[:token] = @token
    session[:email] = user_params[:email]
    Confirmer.confirm_account(@user, @token).deliver
    redirect_to root_path, notice: "Сonfirmation letter has been sent on #{@user.email}. Confirm your mail in order to sign in with your Twitter account"
  end
end
