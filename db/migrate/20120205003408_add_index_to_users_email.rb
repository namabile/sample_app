class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	add_index :users, :email, unqiue: true
  end
end
