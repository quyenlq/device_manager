class AddPortToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :port, :integer
  end
end
