require 'spec_helper'

describe "StaticPages" do
  describe "GET /static_pages" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get static_pages_index_path
      response.status.should be(302) # Redirect due to login and before action presence
    end
  end
end

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('NEW PROJECT') }
    it { should have_title('First Project | Welcome') }
    it { should_not have_title('| Home') }
  end

  describe "for signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      FactoryGirl.create(:micropost, user: user, content: "Lorem")
      FactoryGirl.create(:micropost, user: user, content: "Ipsum")
      login_user user
      visit root_path
    end
    it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
    end
  end



end # END OF describe "Static pages"



  #     it "should render the user's feed" do
  #       user.feed.each do |item|
  #         expect(page).to have_selector("li##{item.id}", text: item.content)
  #       end
  #     end

  #     describe "follower/following counts" do
  #       let(:other_user) { FactoryGirl.create(:user) }
  #       before do
  #         other_user.follow!(user)
  #         visit root_path
  #       end

  #       it { should have_link("0 following", href: following_user_path(user)) }
  #       it { should have_link("1 followers", href: followers_user_path(user)) }
  #     end
  #   end
  # end

#   describe "Welcome Page" do
#     before { visit help_path }

#     it { should have_content('Help') }
#     it { should have_title('First Project | Help') }
#   end

#   describe "About page" do
#     before { visit about_path }

#     it { should have_content('About') }
#     it { should have_title(full_title('About Us')) }
#   end

#   describe "Contact page" do
#     before { visit contact_path }

#     it { should have_selector('h1', text: 'Contact') }
#     it { should have_title(full_title('Contact')) }
#   end

# end
