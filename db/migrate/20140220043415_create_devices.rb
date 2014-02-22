class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.string :address
      t.string :desc
      t.integer :status
      t.string :model

      t.timestamps
    end
  end
end
