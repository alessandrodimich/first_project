require 'spec_helper'

describe "sessions/new.html.erb" do

  it "should have title login" do
    visit login_path
    expect(page).to have_title(full_title("Sign In"))
  end
end
