class DevicesController < ApplicationController
	before_filter :signed_in_user, except: [:watch, :register, :reregister]
	before_filter :admin_user, only: [:show, :index, :edit, :update, :block, :destroy, :approve, :reject]


	# Normal action for user & device client

	def watch
		@device = Device.find(params[:id])
	end

	def register
		if valid_params(params)
			@device = Device.new(get_device_params(params))
			if @device.save	
				render nothing: true, status: :ok
			else
				render text: @device.errors.to_json, status: 400
			end
		else
			render nothing: true, status: 400
		end 
	end

	def reregister
		device = Device.find_by_device_id(params[:device_id])
		if device
		# TODO: update device from params
		else
		end
	end

	def unregister
		device = Device.find_by_device_id(params[:device_id])
		if device
			# unregister device
			device.delete
			render nothing: true, status: :ok
		else render text: "Device not found", status: 400
		end
	end

	# Require admin permission
	def show
		@device = Device.find(params[:id])
	end

	def index
		@devices = Device.all
	end

	def edit
		@device = Device.find(params[:id])
	end

	def approve
		@device = Device.find(params[:id])
		@device.approve!
		flash[:success] = "Device approved"
		redirect_to devices_path
	end

	def reject
		@device = Device.find(params[:id])
		@device.delete
		flash[:success] = "Device rejected"
		redirect_to devices_path
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

	def get_device_params(raw)
		return raw.permit(:name, :address, :device_id, :port, :bitrate)
	end

	def signed_in_user
		redirect_to signin_url, notice: "Please sign in." unless signed_in?
	end

	def admin_user
		redirect_to root_path, notice: "You are not allowed to access this page" unless admin?
	end

	def valid_params(params)
		return  params.include?(:name) && params.include?(:address) && params.include?(:port) && params.include?(:bitrate) && params.include?(:device_id)
	end

end
