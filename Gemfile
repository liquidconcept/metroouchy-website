# encoding: utf-8
source 'http://rubygems.org'

gem 'rack'

group :nanoc do
  gem 'nanoc'

  gem 'sass'
  gem 'compass'
  gem 'therubyracer'

  gem 'sprockets'
  gem 'sprockets-sass'
  gem 'sprockets-helpers'
  gem 'nanoc-sprockets-filter'
  gem 'nanoc-gzip-filter'
  gem 'uglifier'
end

group :development do
  gem 'capistrano'
  gem 'railsless-deploy'
end

group :development, :test do
end

group :guard do
  gem 'rb-fsevent'
  gem 'guard'

  gem 'guard-bundler'
  gem 'guard-livereload'
  gem 'guard-nanoc'

  gem 'ruby_gntp'
end
