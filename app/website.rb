# encoding: utf-8
require 'sinatra/base'
require 'pony'

require File.expand_path('../../config/application', __FILE__)

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
end
