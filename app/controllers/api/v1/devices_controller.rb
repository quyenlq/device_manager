module Api::V1
		class DevicesController < ApplicationController
			before_filter :mobile_signed_in, except: [:register]

			# Normal action for user & device client
			def register
				if valid_params(params)
					@device = Device.new(get_device_params(params, true))
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
				if device && valid_optional_params(params)
					device.update_attributes(get_device_params(params, false))
					render nothing: true, status: 200
				else
					render nothing: true, status: 400
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

			def device_params
				params.require(:device).permit(:name, :address, :device_id, :port, :bitrate)
			end

			def get_device_params(raw, register_flag)
				return raw.permit(:name, :address, :device_id, :port, :bitrate) if register_flag
				return raw.permit(:name, :address, :port, :bitrate)
			end

			def mobile_signed_in
				render text: "Please log-in", status: 400 if User.find_by_remember_token(params[:token]).nil?
			end


			def valid_params(params)
				return  params.include?(:name) && params.include?(:address) && params.include?(:port) && params.include?(:bitrate) && params.include?(:device_id)
			end

			def valid_optional_params(params)
				return  params.include?(:name) || params.include?(:address) || params.include?(:port) || params.include?(:bitrate) || params.include?(:device_id)
			end
		end
	end
end
