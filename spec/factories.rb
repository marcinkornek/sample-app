FactoryGirl.define do
  factory :user do
    sequence(:username)  { |n| "User_#{n}" }
    sequence(:name)      { |n| "Person #{n}" }
    sequence(:email)     { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    state 'verified'
    factory :admin do
      admin true
    end
  end

  factory :user_without_email_confirmation do
    sequence(:username)  { |n| "User_w_#{n}" }
    sequence(:name)      { |n| "Person_w #{n}" }
    sequence(:email)     { |n| "person_w_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    state 'unverified'
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end
end
