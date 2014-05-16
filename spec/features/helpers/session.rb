module SessionHelpers

	def sign_up(email = "sroop@sunar.com",
				password = "12345678",
				password_confirmation = "12345678")
		expect(page.status_code).to eq(200)
		fill_in :email, with: email
		fill_in :password, with: password
		fill_in :password_confirmation, with: password_confirmation
		click_on "Submit"
	end

	def sign_in(email = "test@test.com",
				password = "test")
		visit '/sessions/new'
		fill_in 'email', with: email
		fill_in 'password', with: password
		click_on 'Enter'
	end

	def add_link(url, title, tags)
		within('#new-link') do
			fill_in 'url', with: url
			fill_in 'title', with: title
			fill_in 'tags', with: tags
			click_button 'Add link'
		end
	end


end