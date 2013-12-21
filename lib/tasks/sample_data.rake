namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(first_name: "Example",
                 last_name: "User",
                 user_name: "ExampleUser",
                 email: "example@first-project-dimich.org",
                 password: "foobar",
                 password_confirmation: "foobar")
    for n in 100..200
      first_name = Faker::Name.name.gsub(/[a-zA-Z]+\Z/,"")
      last_name  = Faker::Name.name.gsub(/\A[a-zA-Z]+ /,"")
      user_name = "exampledimich#{n+1}org"
      email = "example-#{n+1}example-first-project-dimich.org"
      password  = "password"
      User.create!(first_name: first_name,
                   last_name: last_name,
                   user_name: user_name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end