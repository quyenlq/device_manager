class AddDefaultValueToDevicesStatus < ActiveRecord::Migration
  def change
  	change_column :devices, :status, :integer, :default => 0	
  end
end
