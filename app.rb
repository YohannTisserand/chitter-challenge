require 'sinatra/base'
require 'sinatra/reloader'
require './lib/peeps'
require './database_connection_setup'
require './lib/user'

class Chitter < Sinatra::Base
  enable :sessions, :method_override
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    redirect '/peeps'
  end

  get '/peeps' do
    @user = User.find(session[:user_id])
    @peeps = Peeps.all
    erb :"peeps/index"
  end

  post '/peeps' do
    Peeps.create(content: params[:peep])
    redirect '/peeps'
  end

  get '/users/new' do
    erb :"users/new"
  end

  post '/users' do
    user = User.create(username: params[:username], email: params[:email], password: params[:password])
    session[:user_id] = user.id
    redirect '/peeps'
  end

  run! if app_file == $0

end
