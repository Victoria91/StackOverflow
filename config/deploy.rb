# config valid only for current version of Capistrano
lock '3.3.3'

set :application, 'qna'
set :repo_url, 'git@github.com:Victoria91/StackOverflow.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/private_pub.yml', '.env', 'config/private_pub_thin.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads', 'db/sphinx', 'binlog')

set :rvm_map_bins, fetch(:rvm_map_bins, []).push('bin/delayed_job')
# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :seed do
  desc "Run a task on a remote server."
  # run like: cap staging rake:invoke task=a_certain_task  
  task :default do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          run("cd #{deploy_to}/current; /usr/bin/env bundle exec rake db:seed")
        end
      end
    end
  end
end


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

end

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml start"
        end
      end
    end
  end

  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml restart"
        end
      end
    end
  end

  desc 'Restart private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml stop"
        end
      end
    end
  end
  
end


namespace :delayed_job do

  def args
    fetch(:delayed_job_args, "")
  end

  def delayed_job_roles
    fetch(:delayed_job_server_role, :app)
  end

  desc 'Stop the delayed_job process'
  task :stop do
    on roles(delayed_job_roles) do
      within release_path do    
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'bin/delayed_job', :stop
        end
      end
    end
  end

  desc 'Start the delayed_job process'
  task :start do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'bin/delayed_job', args, :start
        end
      end
    end
  end

  desc 'Restart the delayed_job process'
  task :restart do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'bin/delayed_job', args, :restart
        end
      end
    end
  end
end

after 'deploy:restart', 'private_pub:restart'
after 'deploy:restart', 'thinking_sphinx:restart'
after 'deploy:restart', 'delayed_job:restart'