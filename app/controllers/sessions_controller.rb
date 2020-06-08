class SessionsController < ApplicationController
  def new
  end
  def create
  	@user = User.find_by email: params[:session][:email].downcase
  	if @user.present? && @user.authenticate(params[:session][:password])
  		login_user @user
      params[:session][:remember_me]=="1" ?  remember(@user): forget(@user)
  		flash[:success]="Login successsful !"
  		redirect_to @user
  	else
  		flash.now[:danger]="Email or Password incorrect !"
  		render :new	
  	end
  end
  def destroy
  	session.delete(:user_id)
    forget(current_user)
  	@current_user=nil
  	flash[:success]="Goobye !"
  	redirect_to root_path
  end
end
