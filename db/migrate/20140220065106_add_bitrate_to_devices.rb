class AddBitrateToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :bitrate, :integer
    add_column :devices, :rating, :integer
  end
end
