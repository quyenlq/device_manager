class RenameDeviceDescToDeviceId < ActiveRecord::Migration
  def change
  	rename_column :devices, :desc, :device_id
  end
end
