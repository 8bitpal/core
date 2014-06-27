require './config/boot'
require 'bundler/capistrano'
require 'whenever/capistrano'
require 'airbrake/capistrano'
require 'new_relic/recipes'

# Multistage deploy
require 'capistrano/ext/multistage'
set :stages, %w(production staging local)
set :default_stage, "local"

require File.expand_path('../../lib/capistrano_recipes/capistrano_database.rb', __FILE__)
require File.expand_path('../../lib/capistrano_recipes/performance.rb', __FILE__)

set :application, 'buckybox'

set :user, application
set :repository, "git@github.com:enspiral/bucky_box.git"
set :keep_releases, 4
set :deploy_via, :remote_cache

set :scm, :git
set :use_sudo, false

set :rake, 'bundle exec rake'
set :whenever_command, 'bundle exec whenever'
set :ssh_options, { :forward_agent => true }

set :whenever_environment, defer { stage }
set :whenever_identifier, defer { "#{application}_#{stage}" }
default_run_options[:pty] = true

namespace :deploy do
  [:stop, :start, :restart].each do |task_name|
    task task_name, :roles => [:app] do
      run "cd #{current_path} && touch tmp/restart.txt"
    end
  end

  task :symlink_configs do
    run %( cd #{release_path} &&
      ln -nfs #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb &&
      ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml &&
      ln -nfs #{shared_path}/log/ #{release_path}/log/
    )
  end

  task :restart_workers do
    sudo %( monit restart delayed_job )
  end

  task :symlink_uploads do
    run %(
      ln -nfs #{shared_path}/private_uploads/ #{release_path}/
    )
  end

  task :symlink_delayed_job_web do
    run %(
      ln -nfs #{shared_path}/bundle/ruby/1.9.1/gems/delayed_job_web-1.2.0/lib/delayed_job_web/application/public #{release_path}/public/delayed_job
    )
  end

  task :symlink_docs do
    run %(
      ln -nfs #{shared_path}/docs/api #{release_path}/public/docs
    )
  end
end

task :setup_private_uploads do
  run %(
    mkdir -p #{shared_path}/private_uploads
  )
end

after 'deploy:assets:symlink' do
  deploy.symlink_configs
  deploy.symlink_uploads
  deploy.symlink_delayed_job_web
  deploy.symlink_docs
end

after "deploy:update_code", "deploy:migrate"
after "deploy:restart", "deploy:restart_workers"
after "deploy:restart", "deploy:cleanup"

after "deploy:restart", "newrelic:notice_deployment"

after "deploy:setup", "setup_private_uploads"

# This is here to provide support of capistrano variables in sprinkle
begin
  Sprinkle::Package::Package.set_variables = self.variables
rescue NameError
end

namespace :provision do
  task :app, :roles => [:app] do
    puts "Provisioing app for #{stage.upcase}"
    puts "#{domain}:#{port}"
    puts "Check that is correct.."
    raise "Bailed out of the provisioning cause I got scared" unless Capistrano::CLI.ui.ask("Super sure? (Y/n)")[0].downcase == 'y'
    if system("bundle exec sprinkle -v -s config/install.rb #{stage}")
      deploy.setup
      deploy
    end
  end

  task :server, :roles => [:app] do
    puts "Provisioing system for #{stage.upcase}"
    puts "#{domain}:#{port}"
    puts "Check that is correct.."
    raise "Bailed out of the provisioning cause I got scared" unless Capistrano::CLI.ui.ask("Super sure? (Y/n)")[0].downcase == 'y'
    system("bundle exec sprinkle -v -s config/install.rb #{stage}")
  end

  task :copy_old_data, :roles => [:db] do
    # Don't prompt to trust key
    put "|1|zPk8yrT60vbIFZ9yWcDS2f4khdY=|oaBi/EPW/ZZzeX7mx5sQJ5SIKZY= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAqBbKLy2pvTiRgz4VGgrRfp5fTZJcn9iRicIys/LF8PTn+bNtelSNdxKSK4V1JsYFy8PzYfR9EASXPkti9uVEYnX4ZmskKNiGuNTcCl29E38f1Ml0bI9mg5ynfjCzRzvzCI9pTNMv+NptyqvM+DMV2pknjxzgzqTZYzbTL/rEy7AgquCJzkFbBpEYzN6R7lNfsNgst9LBcUpHnVgKWyZdQjO9bN1XeANQU2aWTd2pG07hoRNVGYaYi8puNEqCOMaNm1hFKrMXRW6stRNqqD2o6nSpiQfLh1vW9Ufx2YES/qh/glQadc4wub0u9ck4DuumB8elGFk2PK1oQ7faNddedQ==
|1|wGu2HJ6mTMsZaZh7PTjq17aOhE4=|JJcx6qs4i/xvWdv6V/u8b9d+LVQ= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAqBbKLy2pvTiRgz4VGgrRfp5fTZJcn9iRicIys/LF8PTn+bNtelSNdxKSK4V1JsYFy8PzYfR9EASXPkti9uVEYnX4ZmskKNiGuNTcCl29E38f1Ml0bI9mg5ynfjCzRzvzCI9pTNMv+NptyqvM+DMV2pknjxzgzqTZYzbTL/rEy7AgquCJzkFbBpEYzN6R7lNfsNgst9LBcUpHnVgKWyZdQjO9bN1XeANQU2aWTd2pG07hoRNVGYaYi8puNEqCOMaNm1hFKrMXRW6stRNqqD2o6nSpiQfLh1vW9Ufx2YES/qh/glQadc4wub0u9ck4DuumB8elGFk2PK1oQ7faNddedQ==", "/home/#{application}/.ssh/known_hosts_tmp"
    run "cat /home/#{application}/.ssh/known_hosts_tmp >> ~/.ssh/known_hosts"
    run "rm /home/#{application}/.ssh/known_hosts_tmp"

    # Copy prod data
    run(%(ssh bucky_box@my.buckybox.com -C "pg_dump -U bucky_box -i -F c -b bucky_box_production" | pg_restore -O -d bucky_box_#{rails_env}))
  end
end

namespace :deploy do
  namespace :web do
    task :disable, :roles => :web, :except => { :no_release => true } do
      require 'erb'
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }

      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      template = File.read("./app/views/layouts/maintenance.html.erb")
      result = ERB.new(template).result(binding)

      put result, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end
end

# Speed up deployment when assets haven't changed
namespace :deploy do
      namespace :assets do
        task :precompile, :roles => :web, :except => { :no_release => true } do
          from = source.next_revision(current_revision)

          if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
            run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
          else
            logger.info "Skipping application asset pre-compilation because there were no changes"
          end

          if capture("cd #{latest_release} && #{source.local.log(from)} app/controllers/api/ | wc -l").to_i > 0
            run %Q{cd #{latest_release} && RAILS_ENV=#{rails_env} #{rake} apipie:static OUT=#{shared_path}/docs/api}
          else
            logger.info "Skipping API doc pre-compilation because there were no changes"
          end
      end
    end
  end
