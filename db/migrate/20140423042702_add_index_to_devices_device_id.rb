class AddIndexToDevicesDeviceId < ActiveRecord::Migration
  def change
  	add_index  :devices, :device_id, unique: true 
  end
end
