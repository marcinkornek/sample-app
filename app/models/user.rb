class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships,          foreign_key: "follower_id",
                                    dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships,  foreign_key: "followed_id",
                                    class_name:  "Relationship",
                                    dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  has_secure_password
  before_save { email.downcase! }
  before_save { username.downcase! }
  before_create :create_remember_token

  validates :name,      presence: true,
                        length: { maximum: 50 }
                        # uniqueness: { case_sensitive: false }

  VALID_USERNAME_REGEX = /\A[a-z]\w*\z/i
  validates :username,  presence: true,
                        length: { in: 4..50 },
                        uniqueness: { case_sensitive: false },
                        format: { with: VALID_USERNAME_REGEX }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,     presence: true,
                        format: { with: VALID_EMAIL_REGEX },
                        uniqueness: { case_sensitive: false, link: Rails.application.routes.url_helpers.new_password_reset_path }
  validates :password,  length: { minimum: 6 }#, if: lambda {|u| u.password.present?}

  state_machine :state, :initial => :unverified, :action => :bypass_validation do

    event :verify do
      transition :unverified => :verified
    end

    event :unverify do
      transition :verified => :unverified
    end
  end

  def bypass_validation
    if self.changes['state'][1] == 'verified'
      save!(:validate => false)
    else
      save!(:validate => true)
    end
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.posts_for_feed(self)
  end

  def feed_without_user_posts
    Micropost.posts_for_feed_without_user_posts(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user) # wywołuje się ją na instancji => user= User.first , user.unfollow!
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def self.search(query) #metoda jest na klasie => wywołuije się ją na klasie a nie na instancji czyli User.search
    where("name ilike ?", "%#{query}%") # ilike zamiast like => nie jest case sensitive
  end

  def send_password_reset
    generate_password_reset_token
    UserMailer.password_reset(self).deliver
  end

  def generate_password_reset_token
    update_column('password_reset_token', User.new_remember_token)
    update_column('password_reset_sent_at', Time.zone.now)
  end

  def send_activation_token
    generate_activation_token
    UserMailer.confirm_email(self).deliver
  end

  def generate_activation_token
    update_column('activate_email_token', User.new_remember_token)
    update_column('activate_email_sent_at', Time.zone.now)
  end

  def generate_rss_token
    update_column('rss_token', User.new_remember_token)
  end

###########################################################################

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

    def remember_me
    end

end

