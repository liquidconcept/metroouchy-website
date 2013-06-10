# app.rb
require 'sinatra'
require 'sinatra/activerecord'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require './app/uploaders/image_uploader'
require './app/models/new'
require './app/models/event'


set :database, "sqlite3:///db/database.sqlite3"

module Application
  class Website < Sinatra::Base

  end

  class Admin < Sinatra::Base
    use Rack::MethodOverride

    use Rack::Auth::Basic, "Protected Area" do |username, password|
      username == 'admin' && password == '1234'
    end

    get '/' do
      @news = New.all
      @events = Event.order('position ASC')

      erb :"admin/index"
    end

    post '/news/:id' do
      @new = New.find(params[:id])
      @new.update_attributes(params[:new])

      redirect "/admin"
    end

    post '/events' do
      Event.create do |event|
        event.position = Event.count
      end

      redirect "/admin"
    end

    post '/events/:id' do
      @event = Event.find(params[:id])
      @event.update_attributes(params[:event])

      redirect "/admin"
    end

    delete '/events/:id' do
      @event = Event.find(params[:id])
      @event.destroy

      redirect "/admin"
    end

    put '/events/:id/position' do
      @event = Event.where(id: params[:id]).first!
      position_start = @event.position

      @event.update_attributes!(position: params[:position])

      Event.where(['id != ? AND (position >= ? OR position <= ?)', @event.id, position_start, @event.position])
        .update_all(position_start >= @event.position ? 'position = position + 1' : 'position = position - 1')

    end
  end
end
