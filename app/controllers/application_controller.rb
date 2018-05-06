require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end


  get '/' do
    erb :homepage
  end

  get '/signup' do
    erb :'/users/signup'
  end

  get '/login' do
    erb :'/users/login'
  end

  get '/landing' do
    "Landing Page"
  end

  get '/logout' do
    session.clear
  redirect '/login'
 end

  post '/signup' do

      if params[:username].empty? || params[:email].empty? || params[:password].empty?
           redirect "/signup"
       else
         @user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
         @user.save
         if  logged_in? || @user.save
         session[:user_id] = @user.id
         session[:email] = @user.email
         session[:username] = @user.username

         redirect '/landing'
       end
      end
  end

  post "/login" do
     user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          session[:email] = user.email
          session[:username] = user.username
        redirect "/landing"
    else
        redirect "/login"
    end
end




  helpers do
  		def logged_in?
  			!!session[:user_id]
  		end

  		def current_user
  			User.find(session[:user_id])
  		end
  	end
  end
