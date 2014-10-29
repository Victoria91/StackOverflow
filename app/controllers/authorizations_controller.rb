class AuthorizationsController < ApplicationController

  def confirm_auth
    #render json: request.params   
    @user = User.create(user_params.merge(password:'qwerty12123213', password_confirmation:'qwerty12123213'))
    token = Devise.friendly_token[0,30]
    session[:token] = token
    Confirmer.confirm_account(@user, token).deliver
    redirect_to root_path, notice: "Сonfirmation letter has been sent on #{@user.email}. Confirm your mail in order to sign in with your Twitter account"
  end

  def show 
    token = params[:token]
    @asd = 'huraaaah' if token == session[:token]
  end

  private
  def user_params 
    params[:user].permit(:email, authorizations_attributes: [:provider, :uid,])
  end

end
