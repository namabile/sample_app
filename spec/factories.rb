FactoryGirl.define do
	factory :user do
		name "Nick Amabile"
		email "foo@bar.com"
		password "foobar72"
		password_confirmation "foobar72"
	end
end