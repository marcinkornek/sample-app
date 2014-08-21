class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  validate :valid_user_in_private_message  # Custom validation

  before_validation :set_in_reply_to
  scope :without_private_messages, -> { where(in_reply_to: nil) }
  # scope :received_private_messages, -> (user_id) { where(in_reply_to: user_id) }
  scope :received_private_messages, -> (user_id) { where('in_reply_to = ?', user_id) }
  scope :sended_private_messages, -> (user_id) { where('user_id = ? AND in_reply_to IS NOT NULL ', user_id)}

  # Returns microposts from the users being followed by the given user.
  def self.posts_for_feed(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids} AND in_reply_to IS NULL) OR user_id = :user_id OR in_reply_to = :user_id",
          user_id: user.id)
  end

   def self.posts_for_feed_without_user_posts(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids} AND in_reply_to IS NULL) OR in_reply_to = :user_id",
          user_id: user.id)
  end

  def extract_mentioned_user
    # m = /^@(\w*(?:-\w+)*)/.match(content) # works for names with hyphens i.e. bob-abasa-asa
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
    self.in_reply_to = extract_mentioned_user.try(:id)
  end

  #custom validations

  def valid_user_in_private_message
    m = /^@(\S*)/.match(content.downcase)
    if m.present?
      username = m[1]
      unless User.find_by(username: username)
        errors.add(:username, 'doesn\'t exist')
      end
    end
  end

end

