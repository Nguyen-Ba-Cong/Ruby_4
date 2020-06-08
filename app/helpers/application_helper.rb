module ApplicationHelper
	def login_user user
		session[:user_id]=user.id
	end
	def current_user
		if session[:user_id]
			@current_user ||= User.find_by id: session[:user_id]
		elsif cookies.signed[:user_id]
			user=User.find_by id:cookies.signed[:user_id]
			if user.present? && user.authenticate?(cookies[:remember_token])
				@current_user=user
			end
		end
			
	end
	def login?
		return if current_user
		flash[:danger]="You need login"
		redirect_to login_path
	end
	def remember user
		user.remember
        cookies.permanent[:remember_token]=user.remember_token
        cookies.permanent.signed[:user_id]=user.id
	end
	def forget user
		user.forget
        cookies.delete(:remember_token)
        cookies.delete(:user_id)
	end
end
