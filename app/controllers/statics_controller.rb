class StaticsController < ApplicationController
	def home
		@devices = Device.all
		@user = User.new
	end
end
