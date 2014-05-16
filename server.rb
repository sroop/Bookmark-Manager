require 'rack-flash'
require 'data_mapper'
require 'sinatra'
require 'sinatra/base'
require './data_mapper_setup'

class BookmarkManager < Sinatra::Base

	enable :sessions
	set :session_secret, 'super secret'
	use Rack::Flash
	use Rack::MethodOverride


	get '/' do
		@links = Link.all
		erb :index
	end

	post '/links' do
		url = params["url"]
		title = params["title"]
		tags = params["tags"].split(" ").map do |tag|
			Tag.first_or_create(text: tag)
		end
		Link.create(url: url, title: title, tags: tags)
		redirect to('/')
		end

	get '/tags/:text' do
		tag = Tag.first(text: params[:text])
		@links = tag ? tag.links : []
		erb :index
	end

	post '/users/new' do
		@user = User.new
  		erb :"users/new"
	end

	get '/users/new' do
		@user = User.new
  		erb :"users/new"
	end

	post '/users' do
		@user = User.new( email: params[:email],
							password: params[:password],
							password_confirmation: params[:password_confirmation])
		if @user.save
			session[:user_id] = @user.id
			redirect to('/')
		else
			flash.now[:errors] = @user.errors.full_messages
			erb :"users/new"
		end
	end

	get '/sessions/new' do
  		erb :"sessions/new"
	end

	post '/sessions' do
		email, password = params[:email], params[:password]
		user = User.authenticate(email, password)
		if user
			session[:user_id] = user.id
			redirect to('/')
		else
			flash[:errors] = ["The email or password is incorrect"]
			erb :"sessions/new"
		end
	end

	delete '/sessions' do
		session[:user_id] = nil
		flash[:notice] = "Good bye!"
		redirect to('/')
	end

	get '/sessions/recover' do
		erb :"sessions/recover"
	end

	post '/sessions/recover' do
		user = User.recover_password(params[:email]) #either send the email in the method in user model or could just put it in here
		if user
			#send email to user with link
		end
		flash[:notice] = "Recovery email sent!"
		redirect to('/')
	end

	get '/sessions/reset/:token' do
		@token = params[:token]
		erb :"sessions/reset"
	end

	post '/sessions/reset/:token' do
		user = User.first(email: params[:email], token: params[:token])
	
		if user
			user.password = params[:password]
			user.password_confirmation = params[:password_confirmation]
			user.token = nil
			if user.save
				session[:user_id] = user.id
				redirect to('/')
			else
				flash[:notice] = user.errors.full_messages
				redirect to("/sessions/reset/#{params[:token]}")
			end
		end	
		redirect to('/')
	end

helpers do
  	def current_user    
    	User.get(session[:user_id]) if session[:user_id]
  	end
end

end