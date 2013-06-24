# encoding: utf-8
require 'pony'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'fog'
require './app/uploaders/image_uploader'
require './app/models/new'
require './app/models/event'

require File.expand_path('../../config/application', __FILE__)

configure do
  @@config = YAML.load_file('./config/settings.yaml') rescue {}
end

set :database, "sqlite3:///db/database.sqlite3"

module Application
  class Website < Sinatra::Base
    set :static, true
    set :public, File.expand_path('../../public', __FILE__)

    # Form service
    post '/service' do
      template = ERB.new(File.read(File.expand_path('../templates/service.text.erb', __FILE__), :encoding => 'UTF-8'))

      Pony.mail(
        :from     => params[:service][:email],
        :to       => COMMAND_EMAIL_TO_OUCHY,
        :charset  => 'utf-8',
        :subject  => COMMAND_SUBJECT,
        :body     => template.result(binding)
      )

      redirect "/"
    end

    # Form appointment
    post '/appointment' do
      template = ERB.new(File.read(File.expand_path('../templates/appointment.text.erb', __FILE__), :encoding => 'UTF-8'))

      Pony.mail(
        :from     => params[:appointment][:email],
        :to       => COMMAND_EMAIL_TO_OUCHY,
        :charset  => 'utf-8',
        :subject  => COMMAND_SUBJECT,
        :body     => template.result(binding)
      )

      redirect "/"
    end

    # Form perfumery
    post '/product' do
      template = ERB.new(File.read(File.expand_path('../templates/product.text.erb', __FILE__), :encoding => 'UTF-8'))

      Pony.mail(
        :from     => params[:product][:email],
        :to       => COMMAND_EMAIL_TO_OUCHY,
        :charset  => 'utf-8',
        :subject  => COMMAND_SUBJECT,
        :body     => template.result(binding)
      )

      redirect "/"
    end
  end

  class Admin < Sinatra::Base
    use Rack::MethodOverride

    use Rack::Auth::Basic, "Protected Area" do |username, password|
      username == @@config['basic_auth']['username'] && @@config['basic_auth']['password']
    end

    get '/compile' do
      system 'rm public/index.html'
      system 'bundle exec nanoc compile'

      redirect "/admin"
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
      @event = Event.new(params[:event])
      @event.position = Event.count

      if @event.save
        erb :"admin/event"
      else
        status 500
      end
    end

    post '/events/:id' do
      @event = Event.find(params[:id])

      if @event.update_attributes(params[:event])
        erb :"admin/event"
      else
        status 500
      end
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
