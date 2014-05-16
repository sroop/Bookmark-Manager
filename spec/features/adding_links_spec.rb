require 'spec_helper'
require 'user'
require 'link'
require_relative './helpers/session.rb'

	include SessionHelpers

feature "User adds a new link" do

	before(:each) do
    User.create(email: "test@test.com", 
                password: 'test', 
                password_confirmation: 'test')
  	end

	scenario "When logged in" do
		expect(Link.count).to eq(0)
		sign_in('test@test.com', 'test')
		expect(page).to have_content("Welcome")
		add_link("http://www.makersacademy.com/",
			"Makers Academy", 
			'education ruby')
		expect(Link.count).to eq(1)
		link = Link.first
		expect(link.url).to eq("http://www.makersacademy.com/")
		expect(link.title).to eq("Makers Academy")
		expect(link.tags.map(&:text)).to include("education")
		expect(link.tags.map(&:text)).to include("ruby")
	end

end

