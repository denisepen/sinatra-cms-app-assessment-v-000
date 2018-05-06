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
    @user = User.find(session[:user_id])
    erb :"/users/landing"
  end

  get '/logout' do
    session.clear
  redirect '/login'
 end

 get '/workouts/new' do
   erb :'/workouts/new'
 end

 get '/users/workouts' do
   @user = User.find(session[:user_id])
   erb :"/workouts/show"
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

  get '/workouts/:id/edit' do
  if logged_in?
    @user = User.find(session[:user_id])
    @workout = Workout.find(params[:id])
    if @user.id == @workout.user_id

    erb :"/workouts/edit"
  else
    redirect '/workouts'
  end
else
  redirect '/login'
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

post '/workouts/show' do
  #  raise params.inspect
  @workout = Workout.new(type: params[:type], duration: params[:duration], comment: params[:comment])
    @workout.save
  erb :"/workouts/show"
end

delete '/workouts/:id/delete' do

    @workout =Workout.find_by_id(params[:id])
   if  @workout.user_id == session[:user_id] && logged_in?
     @workout.delete
    redirect '/users/workouts'
  else
   redirect '/users/workouts'
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
