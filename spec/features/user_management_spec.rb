require 'spec_helper'
require 'user'

feature "User signs up" do
	scenario "user is able to login" do
		lambda { sign_up }.should change(User, :count).by(1)
		expect(page).to have_content("Welcome, sroop@sunar.com")
		expect(User.first.email).to eq("sroop@sunar.com")
	end

	scenario "with a password that doesn't match" do
		lambda { sign_up('a@a.com', 'pass', 'wrong') }.should change(User, :count).by(0)
	end

	scenario "with a password that doesn't match" do
		lambda { sign_up('a@a.com', 'pass', 'wrong') }.should change(User, :count).by(0)
		expect(current_path).to eq('/users')
		expect(page).to have_content("Password does not match")
	end

	scenario "With an email that is already registered" do
		lambda { sign_up }.should change(User, :count).by(1)
		lambda { sign_up }.should change(User, :count).by(0)
		expect(page).to have_content("Email is already taken")
	end

	def sign_up(email = "sroop@sunar.com",
				password = "12345678",
				password_confirmation = "12345678")
		visit '/users/new'
		expect(page.status_code).to eq(200)
		fill_in :email, with: email
		fill_in :password, with: password
		fill_in :password_confirmation, with: password_confirmation
		click_button "Sign Up"
	end

end