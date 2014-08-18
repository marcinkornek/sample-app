class ChangeInReplyToToInteger < ActiveRecord::Migration
  def change
    change_column :microposts, :in_reply_to, 'integer USING CAST(in_reply_to AS integer)'
    # change_column :microposts, :in_reply_to, :integer
  end
end
