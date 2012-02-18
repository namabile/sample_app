require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign Up') }
    it { should have_selector('title', text: full_title('Sign Up')) }
  end

  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }
  	before { visit user_path(user) }
  	it { should have_selector('h1', 	text: user.name) }
  	it { should have_selector('title', 	text: user.name) }
  end

  describe "signup" do
  	before { visit signup_path }

  	describe "with invalid information" do
  	  it "should not create a new user" do
  	    expect { click_button "Sign up" }.not_to change(User, :count)
  	  end

      describe "error messages" do
        before { click_button "Sign up" }

        let(:error) { 'errors prohibited this user from being saved' }

        it { should have_selector('title', text: 'Sign Up') }
        it { should have_content(error) }
      end
  	end

  	describe "with valid information" do
  	  before do
	   	  fill_in "Name", with: "Example User"
	  	  fill_in "Email", with: "foo@bar.com"
	  	  fill_in "Password", with: "foobar"
	  	  fill_in "Confirmation", with: "foobar"
      end

      describe "after saving the user" do
        before { click_button "Sign up" }
        let(:user) { User.find_by_email('foo@bar.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.flash.success', text: 'Welcome') }
      end
  	end
  end
end