class Device < ActiveRecord::Base
	 # Device : 
	 # - device_id : also the backend channel name, send from wowza via query string
	 # - device_name : device name, send from device to wowza via query string
	 # - ip_address: from the ip send to wowza (properly WAN IP), get from client parametter inside wowza module
	 # - channel_name: named by user, send to wowza via query string
	 # - bitrate: consider latter ------
	belongs_to :user

	VALID_IPV4_REGEX = /\A(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$\z/
 	validates :address, presence:   true,
	format:     { with: VALID_IPV4_REGEX }
	validates :device_id, presence: true, uniqueness: true
	validates :bitrate, presence: true
	validates :channel_name, presence: true
	validates :device_name, presence: true
	validate :blocked_device
	
	before_save :rename_device_name

	def get_status
		case status
		when 0 
			return "<span class='label label-success'>Online</span>".html_safe
		when 1 
			return "<span class='label label-danger'>Offline</span>".html_safe
		end
	end
	def is_online?
		return self.status==0
	end

	def get_bitrate
		return "#{bitrate} kbps"
	end

	def rename_device_name
		self.device_name.gsub!('_', " ")
	end

	private
	def blocked_device
		if(BlockList.find_by_device_id(device_id))
			self.errors.add(:blocked,"This device is blocked")
		end
	end
end
