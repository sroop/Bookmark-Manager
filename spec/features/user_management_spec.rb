require 'spec_helper'
require 'user'

feature "User signs up" do
	scenario "user sees sign up form" do
		visit '/'
		click_on 'Sign Up'
		expect(page).to have_content("Please sign up")
	end

	scenario "fills in form and is signed in" do
		visit '/'
		click_on 'Sign Up'
		lambda { sign_up('a@a.com', 'pass', 'pass') }
		click_on 'Submit'
		expect(page).to have_content("Welcome")
	end

	scenario "with a password that doesn't match" do
		visit '/'
		click_on 'Sign Up'
		lambda { sign_up('a@a.com', 'pass', 'wrong') }.should change(User, :count).by(0)
	end

	scenario "With an email that is already registered" do
		visit '/'
		click_on 'Sign Up'
		lambda { sign_up }.should change(User, :count).by(1)
		visit '/users/new'
		lambda { sign_up }.should change(User, :count).by(0)
		expect(page).to have_content("Email is already taken")
	end

	def sign_up(email = "sroop@sunar.com",
				password = "12345678",
				password_confirmation = "12345678")
		expect(page.status_code).to eq(200)
		fill_in :email, with: email
		fill_in :password, with: password
		fill_in :password_confirmation, with: password_confirmation
		click_on "Submit"
	end

end