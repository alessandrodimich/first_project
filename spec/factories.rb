FactoryGirl.define do

  factory :user do
    sequence(:first_name)  { |n| "Name#{n}" }
    sequence(:last_name)  { |n| "LastName#{n}" }
    sequence(:user_name)  { |n| "user_name#{n}" }
    sequence(:email) { |n| "username_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end

  factory :event do
    name "Test Event"
    user
  end

end

