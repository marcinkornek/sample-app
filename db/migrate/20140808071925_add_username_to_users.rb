class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :integer
  end
end
