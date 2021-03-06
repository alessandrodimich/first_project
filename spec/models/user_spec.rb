require 'spec_helper'

describe User do

  it "should have a many attributes" do
    user = User.new
    user.should respond_to(:first_name)
    user.should respond_to(:last_name)
    user.should respond_to(:user_name)
    user.should respond_to(:email)
    user.should respond_to(:password)
    user.should respond_to(:microposts)
    user.should respond_to(:feed)
  end

  before do
    @user = User.new(first_name: "Example", last_name: "User", user_name: "ExampleUser", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }


  describe "micropost associations" do

    before { @user.save }

    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end

    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
    end



  end #End of Micropost Associations

end



