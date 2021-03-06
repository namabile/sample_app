require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_selector("title", text: "All users") }

    it "should list each users" do
      User.all.each do |user|
        page.should have_selector("li", text: user.name)
      end
    end
  end

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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector("h1", text: "Edit user") }
      it { should have_selector("title", text: "Edit user") }
      it { should have_link("change", href: "http://gravatar.com/emails") }
    end

    describe "with invalid information" do
      let(:error) { "prohibited this user from being saved" }
      before { click_button "Update" }

      it { should have_content(error) }
    end

    describe "with valid information" do
      let(:user)      { FactoryGirl.create(:user) }
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",         with: new_name
        fill_in "Email",        with: new_email
        fill_in "Password",     with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Update"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.flash.success') }
      it { should have_link('Sign out', :href => signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end