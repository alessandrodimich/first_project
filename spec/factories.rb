FactoryGirl.define do

  factory :admin_user do
    first_name     "Alessandro"
    last_name "Dimich"
    email    "dimich.alessandro@gmail.com"
    user_name "dimich-admin"
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :user do
    first_name     "Foo"
    last_name "Bar"
    email    "alessandro.dimich@gmail.com"
    user_name "dimich-foobar"
    password "foobar"
    password_confirmation "foobar"

  end

  factory :new_user do
    first_name     "Alessandro"
    last_name "Dimich"
    email    "dimichsubs@gmail.com"
    user_name "dimich71"
    password "foobar"
    password_confirmation "foobar"

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

