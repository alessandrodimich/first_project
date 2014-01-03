require 'spec_helper'




describe "User Pages-" do

  describe "Check pages response codes" do

    let(:user) { FactoryGirl.create(:user) }

    it "-verify responses" do
      get users_path
      response.status.should be(302)
      get edit_user_path(user.id)
      response.status.should be(302)
      get user_path(user.id)
      response.status.should be(200)
      get new_user_path
      response.status.should be(200)
    end
  end

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Please sign up') }
    it { should have_title(full_title('New User')) }
  end


  describe "signup page" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do

      before do
        fill_in "First Name", with: "User"
        fill_in "Last Name", with: "Example"
        fill_in "Username", with: "example.user"
        fill_in "Email", with: "user@examplecom"
        fill_in "Password", with: "foobar"
      end

      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "First Name", with: "User"
        fill_in "Last Name", with: "Example"
        fill_in "Username", with: "exampleuser"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

 describe "Users Show Page" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      login_user user
    end

    it { should have_title(full_title(full_name(user))) }
    it { should have_content('Name') }

    # describe "pagination" do

    #   before(:all) { 30.times { FactoryGirl.create(:user) } }
    #   after(:all)  { User.delete_all }

    #   it { should have_selector('div.pagination') }

    #   it "should list each user" do
    #     User.paginate(page: 1).each do |user|
    #       expect(page).to have_selector('li', text: user.name)
    #     end
    #   end
    # end

  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    subject { page }

    before { visit user_path(user) }

    it { should have_content(user.user_name) }
    it { should have_title("First Project | #{user.first_name} #{user.last_name}" ) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { login_user user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_xpath("//input[@value='Unfollow']") }
        end

      end # END "following a user"

      describe "unfollowing a user" do

        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_xpath("//input[@value='Follow']") }
        end


      end # END "unfollowing a user"

    end # END "follow/unfollow buttons"

  end


  describe "edit" do

    let(:user) { FactoryGirl.create(:user) }

    before do
      login_user user
      visit edit_user_path(user)
    end

    describe "with valid information" do
      let(:new_first_name)  { "New First Name" }
      let(:new_last_name)  { "New Last Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "First Name",             with: new_first_name
        fill_in "Last Name",             with: new_last_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Password Confirmation", with: user.password
        click_button "Save changes"
      end

      it { should have_title(full_title("#{new_first_name.capitalize} #{new_last_name.capitalize}")) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_content('Your profile has been updated') }
      it { should have_link('Logout', href: logout_path) }
      specify { expect(user.reload.first_name).to  eq new_first_name.capitalize }
      specify { expect(user.reload.last_name).to  eq new_last_name.capitalize }
      specify { expect(user.reload.email).to eq new_email }
    end
  end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        login_user user
        visit following_user_path(user)
      end

      it { should have_title(full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(full_name(other_user), href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        login_user other_user
        visit followers_user_path(other_user)
      end

      it { should have_title(full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(full_name(user), href: user_path(user)) }
    end
  end


end  #End of describe User Pages

describe "Authentication" do

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Microposts controller" do
        describe "submitting to the create action" do
          before { post microposts_path }
          specify { expect(response).to redirect_to(login_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to(login_path) }
        end
      end

      describe "in the users controller" do

          describe "visiting the following page" do
            before { visit following_user_path(user) }
            it { should_not have_title(full_title("Following")) }
          end

          describe "visiting the followers page" do
            before { visit followers_user_path(user) }
            it { should have_title('Sign in') }
          end
      end

    end
  end
end






#     describe "" do
#       it { should have_content("Show") }
#       it { should have_title("First Project") }
#     end

#   end

#   describe "edit" do
#     let(:user) { FactoryGirl.create(:user) }



#     # describe "with invalid information" do
#     #   before { click_button "Save changes" }

#     #   it { should have_content('error') }

#     # end
#   end

#   describe "profile page" do
#     let(:user) { FactoryGirl.create(:user) }
#     let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
#     let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

#     before { visit user_path(user) }

#     subject { page }

#     it { should have_title("First Project | #{user.user_name}") }
#     it { should have_content("NEW PROJECT") }
#     it { should have_content("NEW PROJECT") }
#     it { should have_content("Logged in as #{user.user_name}") }

#     describe "microposts" do
#       it { should have_content(m1.content) }
#       it { should have_content(m2.content) }
#       it { should have_content(user.microposts.count) }
#     end
#   end


# # End require