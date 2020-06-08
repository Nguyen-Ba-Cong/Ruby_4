class UsersController < ApplicationController
	before_action :login?, only: %i(show edit update)
	before_action :load_user, only: %i(show edit update destroy)
	def show

		unless @user
			flash[:danger]="User Not Found !"
			redirect_to root_path
		end
	end
	def index
		@users=User.paginate(page: params[:page], per_page: 10	)
	end
	def new
		@user=User.new
	end
	def create
		@user= User.new user_params
		if @user.save
		   flash[:success]="Create account successful !"
		   login_user @user
           redirect_to @user
		else
		   flash.now[:danger]="Create account fail !"
           render :new
		end
	end
	def edit
       if @user != current_user
       	flash[:danger]="Access denied"
       	redirect_to root_path
       end
	end
	def update
		
		if @user.update user_params
           flash[:success] = " Update account successful !"
           redirect_to @user
       else
       	   flash.now[:danger] =" Update fail !"
       	   render :edit
       end
	end
	def destroy
		if @user.destroy
			flash[:success]="Delete successful !"
		else
			flash[:danger]="Delete fails !"
		end
		redirect_to users_path
	end
	def user_params
		params.require(:user).permit :name,:email,:password,:password_confirmation
	end
	def load_user
		@user=User.find_by id: params[:id]
	end
end
