class DevicesController < ApplicationController
	before_filter :signed_in_user
	before_filter :admin_user, only: [:block]


	# Normal action for user & device client

	def watch
		@device = Device.find(params[:id])
	end

	
	# Require admin permission
	def show
		@device = Device.find(params[:id])
	end

	def index
		if admin?
			@devices = Device.all
		else
			@devices = current_user.devices.all 
		end
	end

	def edit
		@device = Device.find(params[:id])
	end

	def update
		@device = Device.find(params[:id])
		if @device.update_attributes(device_params)
			flash[:success] = "Device information updated"
			redirect_to @device
		else
			flash[:danger] = "Update failed, please check errors below"
			render 'show'
		end
	end

	def block
		@device = Device.find(params[:id])
		unless BlockList.find_by_device_id(@device_id)
			block = BlockList.new(device_id: @device.device_id)
			if block.save
				@device.delete
				flash[:success] = "Device blocked"
				redirect_to devices_path
			else
				flash[:danger] = block.errors
				redirect_to devices_path
			end
		end
	end

	def destroy
		@device = Device.find(params[:id])
		@device.delete
		flash[:danger] = "Device deleted"
		redirect_to devices_path
	end

	private

	def device_params
		params.require(:device).permit(:name, :address, :device_id, :port, :bitrate)
	end

	def get_device_params(raw, register_flag)
		return raw.permit(:name, :address, :device_id, :port, :bitrate) if register_flag
		return raw.permit(:name, :address, :port, :bitrate)
	end

	def signed_in_user
		redirect_to signin_url, warning: "Please sign in." unless signed_in?
	end

	def admin_user
		redirect_to root_path, warning: "You are not allowed to access this page" unless admin?
	end

	def valid_params(params)
		return  params.include?(:name) && params.include?(:address) && params.include?(:port) && params.include?(:bitrate) && params.include?(:device_id)
	end

	def valid_optional_params(params)
		return  params.include?(:name) || params.include?(:address) || params.include?(:port) || params.include?(:bitrate) || params.include?(:device_id)
	end
	
end
