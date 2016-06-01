class InviteUsersController < ApplicationController
  before_action :load_user, only: [:edit, :update]
  before_action :verity_admin?

  def create
    @user = User.find_by email: params[:invite_user][:email].downcase
    if @user
      @user.create_invite_digest
      @user.send_password_reset_email
      flash[:success] = t "flashs.password_reset"
      redirect_to root_url
    else
      flash[:alert] = t "flashs.not_email"
      redirect_to new_invite_user_url
    end
  end

  def update
    if @user.update_attributes password_params
      sign_in @user
      flash[:success] = t "flashs.reset_success"
      redirect_to @user
    else
      flash[:alert] = flash_message "not_updated"
      render :edit
    end
  end

  private
  def load_user
    @user = User.find_by email: params[:email]
  end

  def password_params
    params.require(:user).permit User::PASSWORD_ATTRIBUTES_PARAMS
  end
end
