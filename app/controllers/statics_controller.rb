class StaticsController < ApplicationController
	def home
		@devices = Device.all
	end
end
