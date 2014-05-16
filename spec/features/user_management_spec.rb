require 'spec_helper'
require 'user'
require_relative './helpers/session.rb'

	include SessionHelpers

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

end

feature "User signs in" do

	before(:each) do
    User.create(email: "test@test.com", 
                password: 'test', 
                password_confirmation: 'test')
  	end

	scenario "with the correct logins" do
		visit '/'
		expect(page).to_not have_content("Welcome")
		click_on 'Login'
		expect(page).to have_content("Email:")
		sign_in('test@test.com', 'test')
		expect(page).to have_content("Welcome")
	end

	scenario "with incorrect logins" do
		visit '/'
		expect(page).to_not have_content("Welcome")
		click_on 'Login'
		expect(page).to have_content("Email:")
		sign_in('test@test.com', 'wrong')
		expect(page).to_not have_content("Welcome")
	end

end

feature 'User signs out' do
	
	before(:each) do
    User.create(email: "test@test.com", 
                password: 'test', 
                password_confirmation: 'test')
  	end

  	scenario 'while being signed in' do
  		sign_in('test@test.com', 'test')
  		click_on 'Log Out'
  		expect(page).to have_content("Good bye!")
  		expect(page).to have_content("Login")
  		expect(page).to_not have_content("Welcome")
  	end

end

feature 'User forgets password' do

	before(:each) do
    	User.create(email: "test@test.com", 
                password: 'test', 
                password_confirmation: 'test',
                token: test_token = SecureRandom.hex(32))
  	end
	
	scenario 'can see the password recovery form' do
		visit '/'
		click_on 'Login'
		expect(page).to have_content("Forgotten your password?")
		click_on 'Forgotten your password?'
		expect(page).to have_content("Recover your password")
	end

	scenario 'can request a recovery email' do
		recover_password
		expect(page).to have_content("Recovery email sent!")
	end

	scenario 'can generate a token when recover button is pressed' do
		recover_password
		expect(page).to have_content("Recovery email sent!")
		expect(User.first(email: 'test@test.com').token.length).to eq(64)
	end

	scenario 'resetting the password' do
		visit "/sessions/reset/#{User.first(email: 'test@test.com').token}"
		expect(page).to have_content("Reset your password")
		fill_in 'email', with: "test@test.com"
		fill_in 'password', with: "123"
		fill_in 'password_confirmation', with: "123"
		click_on 'Reset'
		expect(page).to have_content("Welcome")
	end


end
