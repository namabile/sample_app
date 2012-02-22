require 'spec_helper'

describe "AuthenticationPages" do

	subject { page }

	describe "signin" do
		before { visit signin_path }

		it { should have_selector("h1", text: "Sign in") }
		it { should have_selector("title", text: "Sign in") }
	
		describe "with invalid info" do
			before { click_button "Sign in" }
			it { should have_selector('div.flash.error', text: 'Invalid') }

			describe "and visit another page" do
				before { click_link "Home" }
				it {should_not have_selector("div.flash.error") }
			end
		end

		describe "with valid info" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email", with: user.email
				fill_in "Password", with: user.password
				click_button "Sign in"
			end

			it { should have_selector("title", text: user.name) }
			it { should have_link("Profile", href: user_path(user)) }
			it { should have_link("Sign out", href: signout_path) }
			it { should_not have_link("Sign in", href: signin_path) }

			describe "followed by sign out" do
				before { click_link "Sign out" }
				it { should have_link("Sign in") }
			end
		end
	end
end
