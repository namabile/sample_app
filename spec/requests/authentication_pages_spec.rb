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
			before { sign_in(user) }

			it { should have_selector("title", text: user.name) }

			it { should have_link("Users", href: users_path) }
			it { should have_link("Profile", href: user_path(user)) }
			it { should have_link("Sign out", href: signout_path) }
			it { should_not have_link("Sign in", href: signin_path) }
			it { should have_link("Settings", href: edit_user_path(user)) }

			describe "followed by sign out" do
				before { click_link "Sign out" }
				it { should have_link("Sign in") }
			end
		end
	end

	describe "authorization" do

		describe "for non-signed in users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "in the Users controller" do

				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_selector("title", text: "Sign in") }
				end

				describe "submitting the update action" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end
			end
		end

		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			before { sign_in user }

			describe "visiting Users#edit page" do
				before { visit edit_user_path(wrong_user) }
				it { should have_selector('title', text: 'Home') }
			end

			describe "submitting a PUT request to the Users#update action" do
				before { put user_path(wrong_user) }
				specify { response.should redirect_to(root_path) }
			end
		end

		describe "for non-signed users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path(user)
					fill_in "Email", with: user.email
					fill_in "Password", with: user.password
					click_button "Sign in"
				end

				describe "after signing in" do

					it "should render the desired protected page" do
						page.should have_selector('title', text: "Edit user")
					end
				end
			end

			describe "visiting user index" do
				before { visit users_path }
				it { should have_selector("title", text: "Sign in") }
			end
		end
	end
end
