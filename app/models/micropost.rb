class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  before_save :set_in_reply_to
  # scope :all ->
  scope :without_private_messages, -> { where(in_reply_to: nil) }

  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

  def extract_mentioned_user
    # m = /^@(\w*(?:-\w+)*)/.match(content)
    m = /^@(\S*)/.match(content.downcase)
    if m.nil?
      nil
    else
      username = m[1]
      User.find_by(username: username)
    end
  end

  ###################################################################

  private

  #before actions

  def set_in_reply_to
    # p extract_mentioned_user
    # p extract_mentioned_user.try(:id)
    # p '-----------------------------------'
    self.in_reply_to = extract_mentioned_user.try(:id)
  end

end

