class AuthorizationsController < ApplicationController
  def confirm_auth
    @email = params[:email]
    if @email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      @token = Devise.friendly_token[0, 30]
      user = User.find_for_authentication(email: @email)
      @email = user ? user.email : @email
      send_confirmation
    else
      flash[:alert] = "Invalid email: #{@email}"
      render 'authorizations/new'
    end
  end

  def show
    if session['devise.token'].present? && params[:token] == session['devise.token']
      @user = User.find_for_oauth(OmniAuth::AuthHash.new(session['devise.provider_data']), email: session['devise.email'])
      sign_in @user
      flash[:notice] = 'Your email address has been successfully confirmed. You are now signed in with Twitter account'
    else
      flash[:notice] = 'Invalid confirmation. Try to sign up one more time'
    end
    redirect_to root_path
  end

  def new
  end

  private

  def send_confirmation
    session['devise.token'] = @token
    session['devise.email'] = @email
    Confirmer.confirm_account(@email, @token).deliver
    redirect_to root_path, notice: "Сonfirmation letter has been sent on #{@email}. Confirm your mail in order to sign in with your Twitter account"
  end
end
