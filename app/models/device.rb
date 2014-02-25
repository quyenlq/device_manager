class Device < ActiveRecord::Base
	# ADDRESS: IP address
	# PORT: PORT 
	# DEVICE_ID: Unique id, generate from app
	# BITRATE: Bitrate of the stream
	# STATUS: 0-inactive, 1-online, 2-offline, 3-busy
	validates :port, presence: true, numericality: true
	VALID_IPV4_REGEX = /\A(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$\z/
	validates :address, presence:   true,
	format:     { with: VALID_IPV4_REGEX }
	validates :device_id, presence: true, uniqueness: true
	validates :bitrate, presence: true
	validate :blocked_xdevice

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

	private
	def blocked_device
		if(BlockList.find_by_device_id(device_id))
			self.errors.add(:blocked,"This device is blocked")
		end
	end
end
