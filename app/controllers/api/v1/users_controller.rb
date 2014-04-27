module Api::V1
	class UsersController < ApplicationController
		before_filter :mobile_signed_in, only: [:update]

		def create
			@user = User.new(user_params)
			if @user.save
				render text: @user.to_json, status: 200
			else
				render text: @user.errors.to_json, status: 400
			end
		end

		def update
			if @user.update_attributes(user_params)
				render text: @user.to_json, status: 200
			else
				render text: @user.errors.to_json, status: 400
			end
		end

		private

		def mobile_signed_in
			@user = User.find_by_remember_token(params[:remember_token])
			render text: "Please log-in", status: 400 if @user.nil?
		end

		def user_params
			params.require(:user).permit(:password, :password_confirmation, :username, :name)
		end
	end
end