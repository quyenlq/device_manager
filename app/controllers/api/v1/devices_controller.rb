module Api::V1
	class DevicesController < ApplicationController
		before_filter :mobile_signed_in

		# Normal action for user & device client
		def register
			# check device exists to update
			if !@user.devices.find_by_device_id(params[:device_id]).nil?
				@device = @user.devices.find_by_device_id(params[:device_id])
				update_channel @device, params
			else # new device
				if valid_params(params)
					@device = @user.devices.build(get_device_params(params, true))
					if @device.save	
						render nothing: true, status: :ok
					else
						render text: @device.errors.to_json, status: 400
					end 
				else
					render nothing: true, status: 400
				end
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

		private

		def get_device_params(raw, register_flag)
			return raw.permit(:name, :address, :device_id, :device_name, :channel_name, :bitrate) if register_flag
			return raw.permit(:name, :address, :device_name, :channel_name, :bitrate, :status)
		end

		def mobile_signed_in
			@user = User.find_by_remember_token(params[:remember_token])
			render text: "Please log-in", status: 400 if @user.nil?
		end


		def valid_params(params)
			return  params.include?(:device_name) && params.include?(:address) &&  params.include?(:device_id) && params.include?(:channel_name)
		end

		def valid_optional_params(params)
			return  params.include?(:device_name) || params.include?(:address) ||  params.include?(:device_id) || params.include?(:channel_name) || params.include?(:status)
		end


		def update_channel(device,params)
			if valid_optional_params(params)
				device.update_attributes(get_device_params(params, false))
				if device.save	
					render nothing: true, status: :ok
				else
					render text: device.errors.to_json, status: 400
				end 
			else
				render nothing: true, status: 400
			end
		end
	end
end
