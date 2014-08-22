FactoryGirl.define do
  factory :user do
    sequence(:username)  { |n| "User_#{n}" }
    sequence(:name)      { |n| "Person #{n}" }
    sequence(:email)     { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    state 'verified'
    rss_token SecureRandom.urlsafe_base64
    factory :admin do
      admin true
    end
    factory :user_without_email_confirmation do
      state 'unverified'
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end
end

# factory :user <- user - nazwa klasy. Nie może być inaczej. jeśli chcemy zrobić inny przypadek to dodajemy go w środku j.w.

