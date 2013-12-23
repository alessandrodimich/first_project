FactoryGirl.define do

  factory :user do
    first_name     "Alessandro"
    last_name "Dimich"
    email    "dimichsubs@example.com"
    user_name "dimich71"
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :event do
    name "Test Event"
    user
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end

end

