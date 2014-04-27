class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	add_index  :users, :remember_token
  	add_index  :users, :username, unique: true 
  end
end
