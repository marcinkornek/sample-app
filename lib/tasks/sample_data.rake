namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Rake::Task["db:reset"].invoke if Rails.env.development?
    make_users
    make_microposts
    make_relationships
    make_private_microposts
  end

  def make_users
    puts "---------creating users--------------------"
    User.create!(username: "Username",
                 name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true,
                 state: 'verified',
                 rss_token: SecureRandom.urlsafe_base64)
    99.times do |n|
      username  = "Username_#{n+1}"
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(username: username,
                   name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   state: 'verified',
                   rss_token: SecureRandom.urlsafe_base64)
    end
  end

  def make_microposts
    puts "---------creating microposts---------------"
    users = User.all.limit(6)
    50.times do
      content = Faker::Lorem.sentence(10)
      users.each { |user| user.microposts.create!(content: content) }
    end
  end

  def make_relationships
    puts "---------creating relationships------------"
    users = User.all
    user  = users.first
    followed_users = users[2..50]
    followers      = users[3..40]
    followed_users.each { |followed| user.follow!(followed) }
    followers.each      { |follower| follower.follow!(user) }
  end

  def make_private_microposts
    puts "---------creating private microposts--------"
    users = User.all.limit(6)
    5.times do |n|
      n += 1
      content = "@#{User.find_by(id: n).username} #{Faker::Lorem.sentence(5)}"
      users.each { |user| user.microposts.create!(content: content) }
    end
  end

end
