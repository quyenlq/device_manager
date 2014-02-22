class SessionsController < ApplicationController
	def new
	end

	def create
		
		user = User.find_by_email(params[:session][:email].downcase)
		 if user && user.authenticate(params[:session][:password])
		 	sign_in user
    		flash[:success] = "Signed in successful"
    		redirect_back_or root_path
  		 else
    		flash.now[:error] = "Authentication failed, wrong email or password"
    		render 'new'
  		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
