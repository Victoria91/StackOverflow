class Users::ConfirmationsController < Devise::ConfirmationsController
  # POST /resource/confirmation
  def create
    #render json: request.params   
    @user = User.create(user_params.merge(password:'qwerty12123213', password_confirmation:'qwerty12123213'))
    @user.send_confirmation_instructions
    redirect_to root_path, notice: 'confirmation sent'
  end

  private
  def user_params 
    params[:user].permit(:email, authorizations_attributes: [:provider, :uid,])
  end
end