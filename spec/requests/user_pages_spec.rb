require 'spec_helper'

describe "User Pages" do

  describe "GET /users" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      let(:user) { FactoryGirl.create(:user)
      get users_path
      response.status.should be(302)
      get edit_user_path(:user)
      response.status.should be(302)
      #expect(response.body).to have_content("First")
      #expect(page).to have_content("")

    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit users_path }

    subject { page }

    describe "page" do
      it { should have_content("NEW PROJECT") }
      it { should have_title("Edit user") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }

    end
  end









end
# End require