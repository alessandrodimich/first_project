require 'spec_helper'

describe User do

  it "should have  validate the following attributes" do
    user = User.new
    user.should respond_to(:first_name)
    user.should respond_to(:last_name)
    user.should respond_to(:user_name)
    user.should respond_to(:email)
    user.should respond_to(:password)
    user.should respond_to(:microposts)
    user.should respond_to(:feed)
    user.should respond_to(:relationships)
    user.should respond_to(:followed_users)
    user.should respond_to(:following?)
    user.should respond_to(:follow!)
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

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save!
      @user.follow!(other_user)
    end
    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed_user" do
      subject { other_user }
      its(:followers) { should include(@user)}
    end


    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }
      it { should_not be_following(other_user)}
      its(:followed_users) { should_not include(other_user)}
    end
  end

end



