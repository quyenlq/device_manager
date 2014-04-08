module Api::V1
	class SessionsController < ApplicationController
		def create
			@user = User.find_by_username(params[:username].downcase)
			if @user && @user.authenticate(params[:password])
					# return a token
				render text: @user.to_json
			else
				render text: "Wrong username, password", status: 400
			end
		end
	end
end