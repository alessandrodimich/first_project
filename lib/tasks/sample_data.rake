namespace :db do
  desc "Fill database with sample data"

  task populate: :environment do

    User.create!(first_name: "Admin",
                 last_name: "User",
                 user_name: "admin",
                 email: "dimich.alessandro@gmail.com",
                 password: "administrator",
                 password_confirmation: "administrator",
                 admin: true)

    User.create!(first_name: "Example",
                last_name: "User",
                user_name: "ExampleUser",
                email: "example@first-project-dimich.org",
                password: "foobar",
                password_confirmation: "foobar")

    User.create!(first_name: "Alessandro",
            last_name: "Dimich",
            user_name: "dimich71",
            email: "dimichsubs@gmail.com",
            password: "qazxsw",
            password_confirmation: "qazxsw")

    for n in 100..200
      first_name = Faker::Name.name.gsub(/[a-zA-Z]+\Z/,"")
      last_name  = Faker::Name.name.gsub(/\A[a-zA-Z]+ /,"")
      user_name = "example_user#{n+1}"
      email = "example-user#{n+1}@first-project-dimich.org"
      password  = "password"
      User.create!(first_name: first_name,
                   last_name: last_name,
                   user_name: user_name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    users = User.all(limit: 30)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end

    users = User.all
    user  = users.first
    followed_users = users[2..50]
    followers      = users[3..40]
    followed_users.each { |followed| user.follow!(followed) }
    followers.each      { |follower| follower.follow!(user) }

  end
end