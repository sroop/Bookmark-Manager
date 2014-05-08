require 'spec_helper'
require 'user'

feature "User signs up" do
	scenario "when being logged out" do
		lambda { sign_up }.should change(User, :count).by(1)
		expect(page).to have_content("Welcome, sroop@sunar.com")
		expect(User.first.email).to eq("sroop@sunar.com")
	end

	def sign_up(email = "sroop@sunar.com",
				password = "12345678")
		visit '/users/new'
		expect(page.status_code).to eq(200)
		fill_in :email, with: email
		fill_in :password, with: password
		click_button "Sign Up"
	end
end