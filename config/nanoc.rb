# encoding: utf-8
$: << File.expand_path('../..', __FILE__)

require 'rubygems' if RUBY_VERSION < '1.9'
require 'bundler/setup'

require 'sass'
require 'compass'

require 'rails_config'

require 'sprockets'
require 'sprockets-sass'
require 'nanoc-sprockets-filter'
require 'nanoc-gzip-filter'
require 'uglifier'

unless defined?(Settings)
  RailsConfig.load_and_set_settings(RailsConfig.setting_files(File.expand_path('../../config', __FILE__), ENV['RACK_ENV'] || 'development'))
end

require File.expand_path('../../config/carrierwave', __FILE__)

#
# Nanoc
#
module Nanoc
  def self.production?
    ENV['RACK_ENV'] == 'production'
  end

  def self.development?
    !production?
  end
end

#
# Compass
#
Compass.add_project_configuration 'config/compass.rb'

#
# Sprockets
#
Nanoc::Helpers::Sprockets.configure do |config|
  config.environment = Nanoc::Filters::Sprockets.environment
  config.prefix      = '/assets'
  config.digest      = Nanoc.production?
end

# Fix bug with Sprockets namespace
module Sprockets
  module Sass
    Engine = ::Sass::Engine
  end
end if defined? ::Sass::Engine
