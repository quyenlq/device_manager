class Device < ActiveRecord::Base
	# STATUS: 0-inactive, 1-online, 2-offline, 3-busy

	def get_status
		case status
		when 0 
			return "Inactive"
		when 1 
			return "Online"
		when 2 
			return "Offline"
		when 3 
			return "Busy"
		else
			return "Activated"
		end
	end

	def get_bitrate
		return "#{bitrate} kbps"
	end

	def approve!
		update_attribute("status", 2)
	end
end
