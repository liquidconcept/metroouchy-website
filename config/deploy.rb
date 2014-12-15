# encoding: utf-8
set :application, 'website'
set :domain,      'metro-ouchy.ch'
set :server_name, '95.142.162.83'

set :scm,         :git
set :repository,  'git@github.com:liquidconcept/metroouchy-website.git'
set :branch,      'production'

ssh_options[:forward_agent] = true

default_run_options[:pty] = true
default_environment['LC_CTYPE'] = 'en_US.UTF-8'

set :user,        'webpublisher'
set :deploy_via,  :remote_cache
set :deploy_to,   "/var/www/#{domain}/#{application}"
set :use_sudo,    false

set :bundle_without, [:development, :test, :guard]

role :web, server_name                          # Your HTTP server, Apache/etc
role :app, server_name                          # This may be the same as your `Web` server
role :db,  server_name, :primary => true        # This is where Rails migrations will run

set :copy_exclude, ".git/*"
set :build_script, "bundle install && RACK_ENV=\"production\" bundle exec nanoc compile"

namespace :deploy do
  task :start, :roles => :app do
    run "mkdir -p #{File.join(current_path,'tmp')}"
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "mkdir -p #{File.join(current_path,'tmp')}"
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :migrate, :roles => :db, :only => { :primary => true } do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")
    migrate_env = fetch(:migrate_env, "")
    migrate_target = fetch(:migrate_target, :latest)

    directory = case migrate_target.to_sym
                when :current then current_path
                when :latest  then latest_release
                else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
                end

    run "cd #{directory} && #{rake} RAILS_ENV=#{rails_env} #{migrate_env} db:migrate"
  end

  task :migrations do
    set :migrate_target, :latest
    update_code
    migrate
    create_symlink
    restart
  end
end

before 'deploy:finalize_update' do
  run "mkdir -p #{File.join(shared_path,'db')} && rm -f #{File.join(release_path,'db','database.sqlite3')} && ln -s #{File.join(shared_path,'db','database.sqlite3')} #{File.join(release_path,'db','database.sqlite3')}"
  run "mkdir -p #{File.join(shared_path,'config')} && rm -f #{File.join(release_path,'config','settings.yml')} && ln -s #{File.join(shared_path,'config','settings.yml')} #{File.join(release_path,'config','settings.yml')}"
end

before 'deploy:create_symlink' do
  run "cd #{release_path} && RACK_ENV=\"production\" bundle exec nanoc compile > /dev/null"
end

after 'deploy:update', 'deploy:restart'
after 'deploy:update', 'deploy:cleanup'

