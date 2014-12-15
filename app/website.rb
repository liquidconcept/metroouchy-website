# encoding: utf-8
require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'

require 'rails_config'
require 'pony'

require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'fog'

set :root, File.expand_path('../..', __FILE__)
set :environment, ENV['RACK_ENV'] || 'development'
set :database, 'sqlite3:///db/database.sqlite3'

register RailsConfig

require File.expand_path('../../config/application', __FILE__)
require File.expand_path('../../config/nanoc', __FILE__)
require File.expand_path('../../config/compass', __FILE__)
require File.expand_path('../../config/carrierwave', __FILE__)

include Nanoc::Helpers::Sprockets

require './app/uploaders/image_uploader'
require './app/models/new'
require './app/models/event'
require './app/models/bank_day'

module Application

  class Website < Sinatra::Base
    set :static, true
    set :public, File.expand_path('../../public', __FILE__)

    # Form service
    post '/service' do
      if params[:service][:nickname] && params[:service][:nickname].blank?
        template = ERB.new(File.read(File.expand_path('../templates/service.text.erb', __FILE__), :encoding => 'UTF-8'))

        Pony.mail(
          headers: {
            'Reply-To' => params[:service][:email]
          },
          body: template.result(binding)
        )
      end

      redirect "/"
    end

    # Form appointment
    post '/appointment' do
      if params[:appointment][:nickname] && params[:appointment][:nickname].blank?
        template = ERB.new(File.read(File.expand_path('../templates/appointment.text.erb', __FILE__), :encoding => 'UTF-8'))

        Pony.mail(
          headers: {
            'Reply-To' => params[:appointment][:email]
          },
          body: template.result(binding)
        )
      end

      redirect "/"
    end

    # Form perfumery
    post '/product' do
      if params[:product][:nickname] && params[:product][:nickname].blank?
        template = ERB.new(File.read(File.expand_path('../templates/product.text.erb', __FILE__), :encoding => 'UTF-8'))

        Pony.mail(
          headers: {
            'Reply-To' => params[:product][:email]
          },
          body: template.result(binding)
        )
      end

      redirect "/"
    end

    get '/bank/day' do
      BankDay::is_bank_day?(Date.today).to_s
    end
  end

  class Admin < Sinatra::Base
    use Rack::MethodOverride

    use Rack::Auth::Basic, 'Protected Area' do |username, password|
      username == Settings.basic_auth.username && password == Settings.basic_auth.password
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
        redirect "/admin"
      else
        status 500
      end
    end

    post '/events/:id' do
      @event = Event.find(params[:id])

      if @event.update_attributes(params[:event])
        redirect "/admin"
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
