class SendNewFollowerEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :send_new_follower_email, :boolean, default: true
  end
end
