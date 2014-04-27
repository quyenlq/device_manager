class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_id
      t.string :device_name
      t.string :channel_name
      t.string :address
      t.integer :status
      t.integer :bitrate
      t.timestamps
    end
  end
end
