class AddStateToUser < ActiveRecord::Migration
  def change
    add_column :users, :state, :string
    add_column :users, :activate_email_token, :string
    add_column :users, :activate_email_sent_at, :datetime
    add_index :users, :state
  end
end
