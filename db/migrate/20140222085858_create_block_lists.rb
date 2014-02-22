class CreateBlockLists < ActiveRecord::Migration
  def change
    create_table :block_lists do |t|
      t.string :device_id

      t.timestamps
    end
  end
end
