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
    redirect '/'
 end

 get '/show' do
   @user = User.find(session[:user_id])
   erb :"/users/show"
 end

 get '/workouts/:id/edit' do
  #  binding.pry
 if logged_in?
   @user = User.find(session[:user_id])
   @workout = Workout.find(params[:id])
   @user.save
   if @user.id == @workout.user_id

   erb :"/workouts/edit"
 else
   redirect '/users/workouts'
 end
else
 redirect '/login'
end
end

get '/users/workouts' do
  # binding.pry
  #shows a list of all the users workouts
  @user=User.find(session[:user_id])

  if @user.workouts.find_by(workout: "Bike")
    @bike_wkts = @user.workouts.find_each(workout: "Bike") do |wkt|
      wkt.workout
    end
  end
 binding.pry
  erb :"/users/show"
end

 get '/workouts/new' do
   @workouts = Workout.all
   erb :'/workouts/new'
 end

  get '/workouts/workouts' do
    #  @user = User.find(session[:user_id])
    erb :"/workouts/index"
  end

 get '/workouts/show' do
   @user = User.find(session[:user_id])
   @workout = Workout.find(params[:id])
   erb :"workouts/show"
 end

 get '/workouts/:id' do
# shows users single workout
   @workout = Workout.find(params[:id])

  if session[:user_id] == @workout.user_id

    @user = User.find(session[:user_id])
  erb :"workouts/show"
elsif logged_in? && session[:user_id] != @workout.user_id
  @user = User.find(@workout.user_id)
  erb :"workouts/show"
else

  redirect '/login'
end
end


 patch '/workouts/:id' do
 #route to edit a single workout
  # raise params.inspect
  if logged_in?
   @workout=Workout.find(params[:id])
     if !params[:workout].empty?
       @workout.update(workout: params[:workout], duration: params[:duration], comment: params[:comment], mileage: params[:mileage])

      session[:workout] = params[:workout]
      @user = User.find(session[:user_id])
      @user.id = @workout.user_id
      @workout.save
      redirect "/workouts/#{@workout.id}"
    else
      redirect "/workouts/#{@workout.id}/edit"
    end

  end
end



  post '/signup' do

      if params[:username].empty? || params[:email].empty? || params[:password].empty?
           redirect "/signup"
       else
         @user = User.create(:username => params[:username].downcase, :email => params[:email].downcase, :password => params[:password])
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

post '/workouts/show' do
  #new workout created & displayed with this route
    # binding.pry
  @user = User.find(session[:user_id])
  if params[:workout].empty? && params[:new_workout].empty?
    redirect "/workouts/new"
  else
    if params[:new_workout].empty?
    @workout = Workout.new(workout: params[:workout].capitalize, duration: params[:duration], comment: params[:comment], mileage: params[:mileage])
    else
  @workout = Workout.new(workout: params[:new_workout].chomp.capitalize, duration: params[:duration], comment: params[:comment], mileage: params[:mileage])
  end
    @workout.save

    # if !params[:workout] == ("Bike" || "Run" || "Walk" || "Swim")
    #   @mileage = params[:mileage]
    # end

    @user.workouts << @workout
  erb :"/workouts/show"
  end
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
