FactoryGirl.define do
	factory :user do
		name "Nick Amabile"
		email "foo@bar.com"
		password "foobar"
		password_confirmation "foobar"
	end
end