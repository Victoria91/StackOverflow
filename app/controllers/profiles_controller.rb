class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def digest_unsubscribe
    current_user.update(digest: false)
    redirect_to root_path, notice: 'You have successfully unsubscribed on daily digest'
  end

  def show
    @user = current_user
  end
end
