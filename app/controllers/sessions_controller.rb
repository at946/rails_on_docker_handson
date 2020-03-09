class SessionsController < ApplicationController
  before_action :redirect_to_profile_if_signed_in, only: [:new, :create]

  def new
    @user = User.new
  end 

  def create
    @user = User.new(email: params[:user][:email])
    user = User.find_by(email: @user.email.downcase)
    if user && user.authenticate(params[:user][:password])
      flash[:success] = "サインインしました。"
      sign_in user
      redirect_to user
    else
      flash.now[:danger] = "#{User.human_attribute_name(:email)}または#{User.human_attribute_name(:password)}をもう一度確認してください。"
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end