# app.rb
require 'sinatra'
require 'sinatra/activerecord'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require './app/uploaders/image_uploader'
require './app/models/new'


set :database, "sqlite3:///db/database.sqlite3"

module Application
  class Website < Sinatra::Base

  end

  class Admin < Sinatra::Base

    use Rack::Auth::Basic, "Protected Area" do |username, password|
      username == 'admin' && password == '1234'
    end

    get '/' do
      @news = New.all
      erb :"admin/index"
    end

    post '/news/:id' do
      @new = New.find(params[:id])
      @new.update_attributes(params[:new])
      redirect "/admin"
    end

  end
end
